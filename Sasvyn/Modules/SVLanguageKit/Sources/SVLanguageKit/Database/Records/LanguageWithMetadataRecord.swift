//
//  SocialLinkWithMetadataRecord.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//


import SVDatabaseKit
import SVSyncKit
import Foundation

struct LanguageWithMetadataRecord: Codable, FetchableRecord {

    let languageID: String
    let languageCode: String
    let language: String
    let proficiency: Int
    let languageCreatedAt: Date
    let languageUpdatedAt: Date

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
        case languageID = "language_id"
        case languageCode = "language_code"
        case language = "language"
        case proficiency = "proficiency"
        case languageCreatedAt = "language_created_at"
        case languageUpdatedAt = "language_updated_at"

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
