//
//  SyncLocalStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncLocalStore<Entity>: SyncMetadataStore, SyncStateStore, Sendable
where
    ID == Entity.ID
{
    associatedtype Entity: SyncableEntity

    func fetch(id: Entity.ID) async throws -> Entity?

    func save(_ entity: Entity) async throws

    func delete(id: Entity.ID) async throws

    func fetchPendingChanges()
        async throws -> [SyncPendingChange<Entity.ID>]

    func pendingChange(
        id: Entity.ID
    ) async throws -> SyncPendingChange<Entity.ID>?

    func enqueue(
        _ change: SyncPendingChange<Entity.ID>
    ) async throws

    func removePendingChange(
        id: Entity.ID
    ) async throws

    func incrementRetryCount(
        id: Entity.ID
    ) async throws
}
