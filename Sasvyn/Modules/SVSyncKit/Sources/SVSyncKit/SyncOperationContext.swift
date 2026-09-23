//
//  SyncOperationContext.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncOperationContext: Sendable, Codable, Equatable {

    public let operationID: SyncOperationID
    public let operation: SyncOperation
    public let createdAt: Date

    public init(
        operationID: SyncOperationID,
        operation: SyncOperation,
        createdAt: Date = Date()
    ) {
        self.operationID = operationID
        self.operation = operation
        self.createdAt = createdAt
    }
}
