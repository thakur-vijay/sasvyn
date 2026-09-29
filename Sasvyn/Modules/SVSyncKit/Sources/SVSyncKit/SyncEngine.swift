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
            dump(error)
            try? await localStore.markFailed(id: id, error: error.localizedDescription)
            activeSyncs[id] = nil
            throw error
        }
    }

    public func enqueue(
        id: Entity.ID,
        operation: SyncOperation
    ) async throws {
        try await localStore.markPending(
            id: id,
            operation: operation
        )
        
        let metadata = try await localStore.metadata(id: id)
        print("AFTER ENQUEUE:", metadata?.state as Any)
    }

    private func performSync(id: Entity.ID) async throws -> SyncResult<Entity> {
        try Task.checkCancellation()
        let local = try await localStore.fetch(id: id)
        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }
        let metadata = try await localStore.metadata(id: id)

        print("SYNC METADATA:", metadata?.state as Any)
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

        let pending = try await localStore.fetchPendingMetadata()
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
        metadata: SyncMetadata?
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

        switch metadata?.state {

        case .pending:
            print("🟡 SYNC STATE: PENDING")
            print("🟡 ENTITY ID:", local.id)
            print("🟡 BEFORE REMOTE UPDATE")

            let uploaded = try await executeWithRetry {
                print("🟠 INSIDE REMOTE UPDATE")
                
                return try await remoteStore.update(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }

            print("🟢 REMOTE UPDATE SUCCESS")
            print("🟢 UPLOADED VERSION:", uploaded)

            try await localStore.update(uploaded)

            print("🟢 LOCAL UPDATE SUCCESS")

            try await localStore.markSynced(
                id: uploaded.id,
                version: uploaded.syncVersion
            )

            print("🟢 MARKED SYNCED")

            return uploaded

        case .syncing:
            print("🔴 SYNC STATE: SYNCING")
            print("🔴 ENTITY ID:", local.id)
            print("🔴 THROWING alreadySyncing")

            throw SyncError.alreadySyncing

        case .failed:
            print("🟠 SYNC STATE: FAILED")
            print("🟠 ENTITY ID:", local.id)

            let uploaded = try await executeWithRetry {
                print("🟠 INSIDE REMOTE UPDATE (FAILED RETRY)")

                return try await remoteStore.update(
                    local,
                    idempotencyKey: try await operationKey(for: local.id)
                )
            }

            print("🟢 REMOTE UPDATE SUCCESS (FAILED RETRY)")

            try await localStore.update(uploaded)

            print("🟢 LOCAL UPDATE SUCCESS (FAILED RETRY)")

            try await localStore.markSynced(
                id: uploaded.id,
                version: uploaded.syncVersion
            )

            print("🟢 MARKED SYNCED (FAILED RETRY)")

            return uploaded

        case .synced, .idle, nil:
            print("⚪️ SYNC STATE:", metadata?.state as Any)
            print("⚪️ NO UPLOAD REQUIRED")

            break
        }

        if remote.syncVersion > local.syncVersion {
            try await localStore.update(remote)
            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return remote
        }

        if local.syncVersion > remote.syncVersion {
            throw SyncError.conflict
        }

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
        guard let metadata = try await localStore.metadata(id: id) else {
            throw SyncError.metadataNotFound
        }

        guard let operationID = metadata.operationID else {
            throw SyncError.operationIDNotFound
        }

        return operationID
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
