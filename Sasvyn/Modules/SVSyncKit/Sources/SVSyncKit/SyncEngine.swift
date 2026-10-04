//
//  SyncEngine.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation
import SVFoundation

public protocol SyncEngine<Entity>: Sendable {
    associatedtype Entity: SyncableEntity

    @discardableResult
    func sync(id: Entity.ID) async throws -> SyncResult<Entity>
    
    @discardableResult
    func sync() async throws -> SyncResult<[Entity]>

    func enqueue(
        id: Entity.ID,
        operation: SyncOperation,
        entityType: SyncEntityType
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
    
    @discardableResult
    public func sync() async throws -> SyncResult<[Entity]> {
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🔵 SYNC START")

        let localSnapshot = try await localStore.fetch()
        print("📱 LOCAL COUNT:", localSnapshot.count)

        let remote = try await remoteStore.fetch()
        print("☁️ REMOTE COUNT:", remote.count)

        let pendingMetadata = try await localStore.fetchPendingMetadata()
        print("🟡 PENDING METADATA COUNT:", pendingMetadata.count)

        let localByID = Dictionary(
            uniqueKeysWithValues: localSnapshot.map {
                ($0.entity.id, $0.entity)
            }
        )

        let remoteByID = Dictionary(
            uniqueKeysWithValues: remote.map {
                ($0.id, $0)
            }
        )

        let metadataByID: [Entity.ID: SyncMetadata] = Dictionary(
            uniqueKeysWithValues: localSnapshot.compactMap {
                guard let metadata = $0.metadata else {
                    return nil
                }

                return (metadata.id, metadata)
            }
        )

        let pendingMetadataByID = Dictionary(
            uniqueKeysWithValues: pendingMetadata.map {
                ($0.id, $0)
            }
        )

        let metadataByIDFinal = metadataByID.merging(
            pendingMetadataByID
        ) { _, pending in
            pending
        }

        let ids = Set(localByID.keys)
            .union(remoteByID.keys)
            .union(metadataByIDFinal.keys)

        print("🔑 TOTAL IDS TO RECONCILE:", ids.count)

        var results: [SyncResult<Entity>] = []

        for id in ids {
            print("\n🔄 RECONCILING ID:", id)

            let result = try await reconcile(
                local: localByID[id],
                remote: remoteByID[id],
                metadata: metadataByIDFinal[id]
            )

            print("✅ RECONCILE RESULT:", result)

            results.append(result)
        }

        let entities = results.compactMap { result -> Entity? in
            switch result {
            case .uploaded(let entity),
                 .downloaded(let entity),
                 .conflictResolved(let entity):
                return entity

            case .noChange:
                return nil
            }
        }

        print("\n🟢 SYNC FINISHED")
        print("📦 RESULT ENTITY COUNT:", entities.count)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

        return .uploaded(entities)
    }

    @discardableResult
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
    
    private func performSync(id: Entity.ID) async throws -> SyncResult<Entity> {
        try Task.checkCancellation()
        let local = try await localStore.fetch(id: id)
        let metadata = try await localStore.metadata(id: id)
        let remote = try await executeWithRetry {
            try await remoteStore.fetch(id: id)
        }

        return try await reconcile(local: local?.entity, remote: remote, metadata: metadata)
    }
    
    private func reconcile(
        local: Entity?,
        remote: Entity?,
        metadata: SyncMetadata?
    ) async throws -> SyncResult<Entity> {

        print("\n──────── RECONCILE ────────")

        print("📱 LOCAL:", local?.id as Any)
        print("☁️ REMOTE:", remote?.id as Any)
        print("🗂️ METADATA:", metadata?.id as Any)
        print("🔄 STATE:", metadata?.state as Any)
        print("⚙️ OPERATION:", metadata?.operation as Any)

        switch (local, remote) {

        case (nil, nil):
            print("❌ LOCAL + REMOTE BOTH NIL")
            throw SyncError.entityNotFound

        case (nil, let remote?):

            print("☁️ REMOTE ONLY")

            if metadata?.operation == SyncOperation.delete.rawValue {
                print("🗑️ DELETE OPERATION DETECTED")

                try await executeWithRetry {
                    try await remoteStore.delete(
                        id: remote.id,
                        idempotencyKey: try await operationKey(for: remote.id)
                    )
                }

                print("🗑️ REMOTE DELETE SUCCESS")

                try await localStore.deleteMetadata(id: remote.id)

                print("🗑️ METADATA DELETE SUCCESS")

                return .noChange
            }

            print("⬇️ DOWNLOADING REMOTE → LOCAL")

            try await localStore.create(remote)

            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            print("✅ REMOTE DOWNLOADED")

            return .downloaded(remote)

        case (let local?, nil):

            print("📱 LOCAL ONLY")

            guard let metadata else {
                // No local pending mutation.
                // Entity was deleted remotely on another device.
                print("🗑️ NO METADATA → REMOTE DELETION")
                print("🗑️ DELETING STALE LOCAL ENTITY")

                try await localStore.delete(id: local.id)

                return .noChange
            }

            switch metadata.operation {

            case SyncOperation.create.rawValue,
                 SyncOperation.update.rawValue:

                print("⬆️ LOCAL MUTATION EXISTS → UPLOADING LOCAL")

                let uploaded = try await synchronize(
                    local,
                    nil,
                    metadata: metadata
                )

                return .uploaded(uploaded)

            case SyncOperation.delete.rawValue:

                // Entity exists locally but is marked for deletion.
                // Remote is already missing, so deletion is already satisfied.
                print("🗑️ DELETE ALREADY SATISFIED REMOTELY")

                try await localStore.delete(id: local.id)
                try await localStore.deleteMetadata(id: local.id)

                return .noChange

            default:

                print("🗑️ UNKNOWN OPERATION → DELETING STALE LOCAL")

                try await localStore.delete(id: local.id)

                return .noChange
            }

        case (let local?, let remote?):

            print("🔄 LOCAL + REMOTE BOTH EXIST")
            print("📱 LOCAL VERSION:", local.syncVersion)
            print("☁️ REMOTE VERSION:", remote.syncVersion)

            let uploaded = try await synchronize(
                local,
                remote,
                metadata: metadata
            )

            print("✅ LOCAL + REMOTE RECONCILED")

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
    
    public func enqueue(
        id: Entity.ID,
        operation: SyncOperation,
        entityType: SyncEntityType
    ) async throws {
        let operationID = IDGenerator.uuid()
        if (try await localStore.metadata(id: id)) != nil {
            print("metadata found", id)
            try await localStore.markPending(
                id: id,
                operation: operation,
                operationID: operationID
            )
        } else {
            print("Saving metadata", id)
            try await localStore.saveMetadata(
                .init(
                    id: id,
                    entityType: entityType.rawValue,
                    state: .pending,
                    serverVersion: 0,
                    lastSyncedAt: nil,
                    operationID: operationID,
                    operation: operation.rawValue,
                    retryCount: 0,
                    lastError: nil
                )
            )
        }
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
                try await remoteStore.create(
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
            print("Updating local")
            try await localStore.update(remote)
            try await localStore.markSynced(
                id: remote.id,
                version: remote.syncVersion
            )

            return remote
        }

        if local.syncVersion > remote.syncVersion {
            print("Conflict")
            throw SyncError.conflict
        }

        let resolved = try await conflictResolver.resolve(
            local: local,
            remote: remote
        )

        if resolved == remote {
            print("Resolved is remote")
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

        print("Updating local")
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
