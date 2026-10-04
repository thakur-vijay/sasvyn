//
//  SocialLinkWithMetadataRecord.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 30/09/26.
//

import SVDatabaseKit
import SVSyncKit
import Foundation

struct SocialLinkWithMetadataRecord: Codable, FetchableRecord {

    let socialLinkID: String
    let socialLinkType: String
    let socialLinkURL: String
    let socialLinkCreatedAt: Date
    let socialLinkUpdatedAt: Date

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
        case socialLinkID = "social_link_id"
        case socialLinkType = "social_link_type"
        case socialLinkURL = "social_link_url"
        case socialLinkCreatedAt = "social_link_created_at"
        case socialLinkUpdatedAt = "social_link_updated_at"

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
