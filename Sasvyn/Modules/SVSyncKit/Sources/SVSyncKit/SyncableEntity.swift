//
//  SyncableEntity.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncableEntity: Sendable, Codable, Identifiable where ID: Hashable & Sendable & Codable {
    var id: ID { get }
    var syncVersion: Int64 { get }
    var updatedAt: Date { get }
}
