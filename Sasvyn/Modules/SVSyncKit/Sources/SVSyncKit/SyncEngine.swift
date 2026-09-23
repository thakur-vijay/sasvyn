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
            try await localStore.markPendingUpload(id: id)
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
        try await localStore.markPendingUpload(id: id)
    }

    private func performSync(id: Entity.ID) async throws -> SyncResult<Entity> {
        try Task.checkCancellation()
        try await localStore.markSyncing(id: id)
        let local = try await localStore.fetch(id: id)
        let pendingChange = try await localStore.pendingChange(id: id)

        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }

        switch (local, remote) {

        case (nil, nil):
            throw SyncError.entityNotFound

        case (nil, let remote?):
            try await localStore.save(remote)
            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return .downloaded(remote)

        case (let local?, nil):
            switch missingRemoteStrategy {
            case .uploadLocal:
                let uploaded = try await upload(local)
                return .uploaded(uploaded)
            case .deleteLocal:
                try await localStore.delete(id: id)
                try await localStore.removePendingChange(id: id)
                return .noChange
            case .fail:
                throw SyncError.remoteEntityMissing
            }

        case (let local?, let remote?):
            if let pendingChange,
               pendingChange.context.operation != .delete {
                let uploaded = try await upload(
                    local,
                    prioritizeLocalChange: true
                )
                return .uploaded(uploaded)
            }

            return try await reconcile(
                local: local,
                remote: remote
            )
        }
    }

    public func refresh(
        id: Entity.ID
    ) async throws -> Entity? {

        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }

        guard let remote else {
            return nil
        }

        try await localStore.save(remote)

        try await localStore.markSynced(
            id: remote.id,
            version: remote.syncVersion
        )

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

    private func upload(
        _ local: Entity,
        prioritizeLocalChange: Bool = false
    ) async throws -> Entity {

        try Task.checkCancellation()

        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: local.id)
        }

          if !prioritizeLocalChange,
              let remote,
           remote.syncVersion > local.syncVersion {

            let resolved = try await conflictResolver.resolve(
                local: local,
                remote: remote
            )

            if resolved.id == remote.id,
               resolved.syncVersion == remote.syncVersion {
                try await localStore.save(resolved)

                try await localStore.markSynced(
                    id: resolved.id,
                    version: resolved.syncVersion
                )

                return resolved
            }

            return try await uploadResolved(
                resolved,
                remote: remote
            )
        }

        let uploaded: Entity

        if remote == nil {
            uploaded = try await executeWithRetry {
                try await remoteStore.create(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }
        } else {
            uploaded = try await executeWithRetry {
                try await remoteStore.update(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }
        }

        try await localStore.save(uploaded)

        try await localStore.markSynced(
            id: uploaded.id,
            version: uploaded.syncVersion
        )

        return uploaded
    }

    private func uploadResolved(
        _ entity: Entity,
        remote: Entity
    ) async throws -> Entity {

        guard entity.syncVersion >= remote.syncVersion else {
            throw SyncError.conflict
        }

        let uploaded = try await executeWithRetry {
            try await remoteStore.update(
                entity,
                idempotencyKey: try await operationKey(for: entity.id)
            )
        }

        try await localStore.save(uploaded)

        try await localStore.markSynced(
            id: uploaded.id,
            version: uploaded.syncVersion
        )

        return uploaded
    }

    private func reconcile(
        local: Entity,
        remote: Entity
    ) async throws -> SyncResult<Entity> {

        if remote.syncVersion > local.syncVersion {

            try await localStore.save(remote)

            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return .downloaded(remote)
        }

        if local.syncVersion > remote.syncVersion {

            let uploaded = try await upload(local)

            return .uploaded(uploaded)
        }

        if local.updatedAt == remote.updatedAt {
            return .noChange
        }

        let resolved = try await conflictResolver.resolve(
            local: local,
            remote: remote
        )

        if resolved.updatedAt == remote.updatedAt {
            try await localStore.save(resolved)

            try await localStore.markSynced(
                id: resolved.id,
                version: resolved.syncVersion
            )

            return .conflictResolved(resolved)
        }

        let uploaded = try await executeWithRetry {
            try await remoteStore.update(
                resolved,
                idempotencyKey: try await operationKey(for: resolved.id)
            )
        }

        try await localStore.save(uploaded)

        try await localStore.markSynced(
            id: uploaded.id,
            version: uploaded.syncVersion
        )

        return .conflictResolved(uploaded)
    }

    private func operationKey(for id: Entity.ID) async throws -> String {
        if let pending = try await localStore.pendingChange(id: id) {
            return pending.context.operationID.value
        }

        let pending = SyncPendingChange(id: id)
        try await localStore.enqueue(pending)
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
