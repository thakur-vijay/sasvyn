import Testing
import Foundation
@testable import SVSyncKit

private struct TestEntity: SyncableEntity, Equatable {
    let id: String
    let syncVersion: Int64
    let updatedAt: Date
    let value: String
}

private actor TestLocalStore: SyncLocalStore {
    typealias Entity = TestEntity
    typealias ID = String

    var entities: [String: TestEntity] = [:]
    var metadataByID: [String: SyncMetadata<String>] = [:]
    var pending: [String: SyncPendingChange<String>] = [:]

    func fetch(id: String) async throws -> TestEntity? { entities[id] }
    func save(_ entity: TestEntity) async throws { entities[entity.id] = entity }
    func delete(id: String) async throws { entities[id] = nil }
    func metadata(id: String) async throws -> SyncMetadata<String>? { metadataByID[id] }
    func saveMetadata(_ metadata: SyncMetadata<String>) async throws { metadataByID[metadata.id] = metadata }
    func deleteMetadata(id: String) async throws { metadataByID[id] = nil }
    func fetchPendingChanges() async throws -> [SyncPendingChange<String>] { Array(pending.values) }
    func pendingChanges() async throws -> [SyncPendingChange<String>] { Array(pending.values) }
    func pendingChange(id: String) async throws -> SyncPendingChange<String>? { pending[id] }
    func enqueue(_ change: SyncPendingChange<String>) async throws { pending[change.id] = change }
    func removePendingChange(id: String) async throws { pending[id] = nil }
    func incrementRetryCount(id: String) async throws {
        guard let change = pending[id] else { return }
        pending[id] = SyncPendingChange(
            id: change.id,
            context: change.context,
            retryCount: change.retryCount + 1
        )
    }
    func markPendingUpload(id: String) async throws {}
    func markSyncing(id: String) async throws {}
    func markSynced(id: String, version: Int64) async throws {}
    func markFailed(id: String, error: Error) async throws {}
}

private actor TestRemoteStore: SyncRemoteStore {
    typealias Entity = TestEntity

    var entity: TestEntity?
    var fetchCount = 0
    var updateCount = 0
    var transientFailuresRemaining = 0

    func fetch(id: String) async throws -> TestEntity? {
        fetchCount += 1
        if transientFailuresRemaining > 0 {
            transientFailuresRemaining -= 1
            throw TestRetryableError()
        }
        return entity
    }

    func create(_ entity: TestEntity, idempotencyKey: String) async throws -> TestEntity {
        self.entity = entity
        return entity
    }

    func update(_ entity: TestEntity, idempotencyKey: String) async throws -> TestEntity {
        updateCount += 1
        self.entity = entity
        return entity
    }

    func delete(id: String, idempotencyKey: String) async throws { entity = nil }
}

private struct TestRetryableError: Error, Sendable, SyncRetryableError {
    let isRetryable = true
}

private struct TestRetryStrategy: SyncRetryStrategy {
    func decision(for error: Error) -> SyncRetryDecision {
        error is TestRetryableError ? .retry : .doNotRetry
    }
}

private struct ImmediateSleeper: SyncSleeper {
    func sleep(for duration: TimeInterval) async throws {}
}

private struct TestResolver: SyncConflictResolver {
    typealias Entity = TestEntity

    func resolve(local: TestEntity, remote: TestEntity) async throws -> TestEntity {
        local
    }
}

private func makeEntity(version: Int64, value: String) -> TestEntity {
    TestEntity(
        id: "entity",
        syncVersion: version,
        updatedAt: Date(timeIntervalSince1970: TimeInterval(version)),
        value: value
    )
}

@Test func downloadsWhenServerIsNewer() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    try await local.save(makeEntity(version: 1, value: "old"))
    await remote.setEntity(makeEntity(version: 2, value: "new"))

    let engine = DefaultSyncEngine(
        localStore: local,
        remoteStore: remote,
        conflictResolver: TestResolver()
    )

    let result = try await engine.sync(id: "entity")
    guard case .downloaded(let entity) = result else { Issue.record("Expected a download") ; return }
    #expect(entity.value == "new")
    let saved = try await local.fetch(id: "entity")
    #expect(saved?.value == "new")
}

@Test func uploadsWhenLocalIsNewer() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    try await local.save(makeEntity(version: 2, value: "local"))
    await remote.setEntity(makeEntity(version: 1, value: "remote"))

    let engine = DefaultSyncEngine(localStore: local, remoteStore: remote, conflictResolver: TestResolver())
    let result = try await engine.sync(id: "entity")

    guard case .uploaded(let entity) = result else { Issue.record("Expected an upload") ; return }
    #expect(entity.value == "local")
    let updateCount = await remote.updateCount
    #expect(updateCount == 1)
}

@Test func conflictResolverControlsSameVersionChanges() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    try await local.save(TestEntity(
        id: "entity",
        syncVersion: 1,
        updatedAt: Date(timeIntervalSince1970: 2),
        value: "local"
    ))
    await remote.setEntity(makeEntity(version: 1, value: "remote"))

    let engine = DefaultSyncEngine(localStore: local, remoteStore: remote, conflictResolver: TestResolver())
    let result = try await engine.sync(id: "entity")

    guard case .conflictResolved(let entity) = result else { Issue.record("Expected a conflict resolution") ; return }
    #expect(entity.value == "local")
    let updateCount = await remote.updateCount
    #expect(updateCount == 1)
}

@Test func pendingLocalChangeUploadsDespiteOlderTimestamp() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    try await local.save(TestEntity(
        id: "entity",
        syncVersion: 1,
        updatedAt: Date(timeIntervalSince1970: 1),
        value: "local"
    ))
    try await local.enqueue(SyncPendingChange(id: "entity"))
    await remote.setEntity(makeEntity(version: 2, value: "remote"))

    let engine = DefaultSyncEngine(localStore: local, remoteStore: remote, conflictResolver: TestResolver())
    let result = try await engine.sync(id: "entity")

    guard case .uploaded(let entity) = result else { Issue.record("Expected a pending local change to upload") ; return }
    #expect(entity.value == "local")
    #expect(await remote.updateCount == 1)
}

@Test func duplicateRequestsDoNotStartTwoRemoteFetches() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    await remote.setEntity(makeEntity(version: 1, value: "remote"))
    let engine = DefaultSyncEngine(localStore: local, remoteStore: remote, conflictResolver: TestResolver())

    async let first = engine.sync(id: "entity")
    async let second = engine.sync(id: "entity")
    _ = try await (first, second)

    let fetchCount = await remote.fetchCount
    #expect(fetchCount == 1)
}

@Test func retriesClassifiedTransientFailures() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    await remote.setEntity(makeEntity(version: 1, value: "remote"))
    await remote.setTransientFailures(2)

    let engine = DefaultSyncEngine(
        localStore: local,
        remoteStore: remote,
        conflictResolver: TestResolver(),
        retryPolicy: SyncRetryPolicy(maxRetries: 2, baseDelay: 0, maxDelay: 0, jitterFactor: 0),
        retryStrategy: TestRetryStrategy(),
        sleeper: ImmediateSleeper()
    )

    let result = try await engine.sync(id: "entity")
    guard case .downloaded = result else { Issue.record("Expected a download after retries") ; return }
    #expect(await remote.fetchCount == 3)
}

@Test func canRejectMissingRemoteEntities() async throws {
    let local = TestLocalStore()
    let remote = TestRemoteStore()
    try await local.save(makeEntity(version: 1, value: "local"))

    let engine = DefaultSyncEngine(
        localStore: local,
        remoteStore: remote,
        conflictResolver: TestResolver(),
        missingRemoteStrategy: .fail
    )

    do {
        _ = try await engine.sync(id: "entity")
        Issue.record("Expected missing remote failure")
    } catch let error as SyncError {
        #expect(error == .remoteEntityMissing)
    }
}

private extension TestRemoteStore {
    func setEntity(_ entity: TestEntity) { self.entity = entity }
    func setTransientFailures(_ count: Int) { transientFailuresRemaining = count }
}
