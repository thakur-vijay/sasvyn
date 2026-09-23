//
//  SyncPendingChange.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncPendingChange<ID: Hashable & Sendable & Codable>: Sendable {

    public let id: ID
    public let context: SyncOperationContext
    public let retryCount: Int

    public init(
        id: ID,
        context: SyncOperationContext = SyncOperationContext(
            operationID: SyncOperationID(),
            operation: .update
        ),
        retryCount: Int = 0
    ) {
        self.id = id
        self.context = context
        self.retryCount = retryCount
    }
}
