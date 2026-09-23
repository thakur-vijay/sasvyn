//
//  SyncResult.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncResult<Entity: SyncableEntity>: Sendable {
    case noChange
    case downloaded(Entity)
    case uploaded(Entity)
    case conflictResolved(Entity)
}
