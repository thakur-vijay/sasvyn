//
//  SyncMetadata.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncMetadata: Sendable, Hashable {

    public let id: String
    public let entityType: String

    public var state: SyncState
    public var serverVersion: Int64
    public var lastSyncedAt: Date?

    public var operationID: String?
    public var operation: String?

    public var retryCount: Int
    public var lastError: String?

    public init(
        id: String,
        entityType: String,
        state: SyncState,
        serverVersion: Int64 = 0,
        lastSyncedAt: Date? = nil,
        operationID: String? = nil,
        operation: String? = nil,
        retryCount: Int = 0,
        lastError: String? = nil
    ) {
        self.id = id
        self.entityType = entityType
        self.state = state
        self.serverVersion = serverVersion
        self.lastSyncedAt = lastSyncedAt
        self.operationID = operationID
        self.operation = operation
        self.retryCount = retryCount
        self.lastError = lastError
    }
}
