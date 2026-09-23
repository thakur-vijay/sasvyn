//
//  SyncMetadataStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncMetadataStore<ID>: Sendable {
    associatedtype ID: Hashable & Sendable & Codable

    func metadata(
        id: ID
    ) async throws -> SyncMetadata<ID>?

    func saveMetadata(
        _ metadata: SyncMetadata<ID>
    ) async throws

    func deleteMetadata(
        id: ID
    ) async throws
}
