//
//  LocalEntitySnapshot.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 30/09/26.
//

import Foundation

public struct LocalEntitySnapshot<Entity: SyncableEntity>: Sendable {
    public let entity: Entity
    public let metadata: SyncMetadata?
    
    public init(entity: Entity, metadata: SyncMetadata?) {
        self.entity = entity
        self.metadata = metadata
    }
}
