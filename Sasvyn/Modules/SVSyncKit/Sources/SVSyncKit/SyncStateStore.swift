//
//  SyncStateStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncStateStore<ID>: Sendable {
    associatedtype ID: Hashable & Sendable & Codable

    func markPendingUpload(id: ID) async throws

    func markSyncing(id: ID) async throws

    func markSynced(
        id: ID,
        version: Int64
    ) async throws

    func markFailed(
        id: ID,
        error: Error
    ) async throws
}
