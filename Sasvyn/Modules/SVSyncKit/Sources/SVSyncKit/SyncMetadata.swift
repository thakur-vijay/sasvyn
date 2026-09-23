//
//  SyncMetadata.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncMetadata<ID: Hashable & Sendable>: Sendable {
    public let id: ID
    public var state: SyncState
    public var lastSyncedAt: Date?
    public var lastError: String?

    public init(
        id: ID,
        state: SyncState,
        lastSyncedAt: Date? = nil,
        lastError: String? = nil
    ) {
        self.id = id
        self.state = state
        self.lastSyncedAt = lastSyncedAt
        self.lastError = lastError
    }
}
