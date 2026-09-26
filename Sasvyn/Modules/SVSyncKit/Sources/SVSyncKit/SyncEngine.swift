//
//  SyncEngine.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncEngine<Entity>: Sendable {
    associatedtype Entity: SyncableEntity

    func sync(id: Entity.ID) async throws -> SyncResult<Entity>

    func enqueue(
        id: Entity.ID,
        operation: SyncOperation
    ) async throws

    func syncPendingChanges() async throws

    func refresh(id: Entity.ID) async throws -> Entity?
}


public actor DefaultSyncEngine<
    Local: SyncLocalStore,
    Remote: SyncRemoteStore,
    Resolver: SyncConflictResolver
>: SyncEngine
where
    Local.Entity == Remote.Entity,
    Remote.Entity == Resolver.Entity
{
    public typealias Entity = Local.Entity

    private let localStore: Local
    private let remoteStore: Remote
    private let conflictResolver: Resolver
    private let retryPolicy: SyncRetryPolicy
    private let retryStrategy: any SyncRetryStrategy
    private let sleeper: any SyncSleeper
    private let missingRemoteStrategy: SyncMissingRemoteStrategy

    private var activeSyncs: [Entity.ID: Task<SyncResult<Entity>, Error>] = [:]

    public init(
        localStore: Local,
        remoteStore: Remote,
        conflictResolver: Resolver,
        retryPolicy: SyncRetryPolicy = SyncRetryPolicy(),
        retryStrategy: any SyncRetryStrategy = DefaultSyncRetryStrategy(),
        sleeper: any SyncSleeper = DefaultSyncSleeper(),
        missingRemoteStrategy: SyncMissingRemoteStrategy = .uploadLocal
    ) {
        self.localStore = localStore
        self.remoteStore = remoteStore
        self.conflictResolver = conflictResolver
        self.retryPolicy = retryPolicy
        self.retryStrategy = retryStrategy
        self.sleeper = sleeper
        self.missingRemoteStrategy = missingRemoteStrategy
    }

    public func sync(
        id: Entity.ID
    ) async throws -> SyncResult<Entity> {

        if let activeSync = activeSyncs[id] {
            return try await activeSync.value
        }

        let activeSync = Task { [self] in
            try await performSync(id: id)
        }
        activeSyncs[id] = activeSync

        do {
            let result = try await withTaskCancellationHandler {
                try await activeSync.value
            } onCancel: {
                activeSync.cancel()
            }
            activeSyncs[id] = nil
            return result
        } catch {
            try? await localStore.markFailed(id: id, error: error)
            activeSyncs[id] = nil
            throw error
        }
    }

    public func enqueue(
        id: Entity.ID,
        operation: SyncOperation = .update
    ) async throws {
        if let pending = try await localStore.pendingChange(id: id) {
            try await localStore.markPending(id: id)
            try await localStore.enqueue(pending)
            return
        }

        try await localStore.enqueue(
            SyncPendingChange(
                id: id,
                context: SyncOperationContext(
                    operationID: SyncOperationID(),
                    operation: operation
                )
            )
        )
        try await localStore.markPending(id: id)
    }

    private func performSync(id: Entity.ID) async throws -> SyncResult<Entity> {
        try Task.checkCancellation()
        let local = try await localStore.fetch(id: id)
        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }
        let metadata = try await localStore.metadata(id: id)
        switch (local, remote) {

        case (nil, nil):
            throw SyncError.entityNotFound

        case (nil, let remote?):
            try await localStore.create(remote)
            try await localStore.markSynced(id: remote.id, version: remote.syncVersion)
            return .downloaded(remote)
        case (let local?, nil):
            switch missingRemoteStrategy {
            case .uploadLocal:
                let uploaded = try await synchronize(local, nil, metadata: metadata)
                return .uploaded(uploaded)
            case .deleteLocal:
                try await localStore.delete(id: id)
                return .noChange
            case .fail:
                throw SyncError.remoteEntityMissing
            }

        case (let local?, let remote?):
            let uploaded = try await synchronize(
                local,
                remote,
                metadata: metadata
            )
            return .uploaded(uploaded)
        }
    }

    public func refresh(
        id: Entity.ID
    ) async throws -> Entity? {

        guard let remote = (try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }) else { return nil}
        try await localStore.create(remote)
        return remote
    }

    public func syncPendingChanges() async throws {

        let pending = try await localStore.fetchPendingChanges()
        var firstError: Error?

        for change in pending {

            do {
                _ = try await sync(id: change.id)
            } catch is CancellationError {
                throw SyncError.cancelled
            } catch {
                try? await localStore.incrementRetryCount(id: change.id)
                firstError = firstError ?? error
            }
        }

        if let firstError {
            throw firstError
        }
    }

    private func synchronize(
        _ local: Entity,
        _ remote: Entity?,
        metadata: SyncMetadata<Entity.ID>?
    ) async throws -> Entity {

        try Task.checkCancellation()

        guard let remote else {
            let uploaded = try await executeWithRetry {
                try await remoteStore.update(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }

            try await localStore.update(uploaded)
            try await localStore.markSynced(
                id: uploaded.id,
                version: uploaded.syncVersion
            )

            return uploaded
        }

        // Local has an explicit pending change.
        if metadata?.state == .pending {

            let uploaded = try await executeWithRetry {
                try await remoteStore.update(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }

            try await localStore.update(uploaded)
            try await localStore.markSynced(
                id: uploaded.id,
                version: uploaded.syncVersion
            )

            return uploaded
        }

        // No pending local change:
        // remote is newer → download.
        if remote.syncVersion > local.syncVersion {
            try await localStore.update(remote)
            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return remote
        }

        // Local is newer without a pending operation.
        // Do not silently overwrite remote.
        if local.syncVersion > remote.syncVersion {
            throw SyncError.conflict
        }

        // Same version → resolve only if data actually differs.
        let resolved = try await conflictResolver.resolve(
            local: local,
            remote: remote
        )

        if resolved == remote {
            try await localStore.update(remote)
            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return remote
        }

        if resolved.syncVersion < remote.syncVersion {
            throw SyncError.conflict
        }

        let uploaded = try await executeWithRetry {
            try await remoteStore.update(
                resolved,
                idempotencyKey: try await operationKey(for: resolved.id)
            )
        }

        try await localStore.update(uploaded)
        try await localStore.markSynced(
            id: uploaded.id,
            version: uploaded.syncVersion
        )

        return uploaded
    }

    private func operationKey(for id: Entity.ID) async throws -> String {
        guard let pending = try await localStore.pendingChange(id: id) else {
            throw SyncError.pendingChangeNotFound
        }

        return pending.context.operationID.value
    }
    
    private func executeWithRetry<T: Sendable>(
        operation: @Sendable () async throws -> T
    ) async throws -> T {

        var retryCount = 0

        while true {
            try Task.checkCancellation()

            do {
                return try await operation()
            } catch is CancellationError {
                throw SyncError.cancelled
            } catch {
                guard retryStrategy.decision(for: error) == .retry else {
                    throw error
                }

                guard retryPolicy.shouldRetry(
                    retryCount: retryCount
                ) else {
                    throw error
                }

                let delay = retryPolicy.delay(
                    retryCount: retryCount
                )

                try await sleeper.sleep(
                    for: delay
                )

                retryCount += 1
            }
        }
    }
}
