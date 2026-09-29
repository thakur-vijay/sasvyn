//
//  SyncLocalStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncLocalStore<Entity>: SyncMetadataStore, Sendable
where
    Entity.ID == String
{
    associatedtype Entity: SyncableEntity

    func fetch(id: Entity.ID) async throws -> Entity?

    func create(_ entity: Entity) async throws

    func update(_ entity: Entity) async throws

    func delete(id: Entity.ID) async throws
}
