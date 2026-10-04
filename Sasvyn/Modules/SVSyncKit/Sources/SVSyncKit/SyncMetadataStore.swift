//
//  SyncMetadataStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncMetadataStore: Sendable {

    func metadata(
        id: String
    ) async throws -> SyncMetadata?

    func saveMetadata(
        _ metadata: SyncMetadata
    ) async throws

    func deleteMetadata(
        id: String
    ) async throws
    
    func fetchMetadata() async throws -> [SyncMetadata]

    func fetchPendingMetadata()
        async throws -> [SyncMetadata]

    func markPending(
        id: String,
        operation: SyncOperation,
        operationID: String
    ) async throws

    func markSyncing(
        id: String
    ) async throws

    func markSynced(
        id: String,
        version: Int64
    ) async throws

    func markFailed(
        id: String,
        error: String
    ) async throws

    func incrementRetryCount(
        id: String
    ) async throws
}
