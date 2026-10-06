//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation
import SVDatabaseKit
import SVSyncKit

struct SkillWithMetadataRecord: Codable, FetchableRecord {

    let id: String
    let skill: String
    let category: String
    let createdAt: Date
    let updatedAt: Date

    let metadataID: String?
    let entityType: String?
    let entityID: String?
    let syncStatus: SyncStatus?
    let serverVersion: Int64?
    let syncedAt: Date?
    let syncOperationID: String?
    let syncOperation: String?
    let syncRetryCount: Int?
    let syncError: String?

    enum CodingKeys: String, CodingKey {

        case id
        case skill
        case category
        case createdAt = "created_at"
        case updatedAt = "updated_at"

        case metadataID = "metadata_id"
        case entityType = "entity_type"
        case entityID = "entity_id"
        case syncStatus = "sync_status"
        case serverVersion = "server_version"
        case syncedAt = "synced_at"
        case syncOperationID = "sync_operation_id"
        case syncOperation = "sync_operation"
        case syncRetryCount = "sync_retry_count"
        case syncError = "sync_error"
    }
}
