//
//  SyncRemoteStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncRemoteStore<Entity>: Sendable {
    associatedtype Entity: SyncableEntity

    func fetch(id: Entity.ID) async throws -> Entity?

    func create(
        _ entity: Entity,
        idempotencyKey: String
    ) async throws -> Entity

    func update(
        _ entity: Entity,
        idempotencyKey: String
    ) async throws -> Entity

    func delete(
        id: Entity.ID,
        idempotencyKey: String
    ) async throws
}
