//
//  SyncConflictResolver.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncConflictResolver<Entity>: Sendable {
    associatedtype Entity: SyncableEntity

    func resolve(
        local: Entity,
        remote: Entity
    ) async throws -> Entity
}

public struct DefaultSyncConflictResolver<Entity: SyncableEntity>: SyncConflictResolver {

    public enum Strategy: Sendable {
        case localWins
        case remoteWins
        case latestUpdatedAt
    }

    private let strategy: Strategy

    public init(strategy: Strategy = .latestUpdatedAt) {
        self.strategy = strategy
    }

    public func resolve(
        local: Entity,
        remote: Entity
    ) async throws -> Entity {
        switch strategy {
        case .localWins:
            return local

        case .remoteWins:
            return remote

        case .latestUpdatedAt:
            return local.updatedAt >= remote.updatedAt
                ? local
                : remote
        }
    }
}
