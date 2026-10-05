//
//  SyncLocalStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncLocalStore<Entity>: Sendable where Entity.ID == String {
    associatedtype Entity: SyncableEntity
    
    func fetch() async throws -> [LocalEntitySnapshot<Entity>]

    func fetch(id: Entity.ID) async throws -> LocalEntitySnapshot<Entity>?

    func create(_ entity: Entity) async throws

    func update(_ entity: Entity) async throws

    func delete(id: Entity.ID) async throws
}
