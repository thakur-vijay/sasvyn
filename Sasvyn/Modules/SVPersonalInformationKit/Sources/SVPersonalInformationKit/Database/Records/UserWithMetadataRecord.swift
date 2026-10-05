//
//  UserWithMetadataRecord.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
import SVDatabaseKit
import SVSyncKit

struct UserWithMetadataRecord: Codable, FetchableRecord {

    let userID: String
    let userAppleID: String
    let userFullName: String
    let userEmail: String
    let userDateOfBirth: Date?
    let userImageLocalPath: String?
    let userImageURL: String?
    let userCreatedAt: Date
    let userUpdatedAt: Date

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

        case userID = "user_id"
        case userAppleID = "user_apple_id"
        case userFullName = "user_full_name"
        case userEmail = "user_email"
        case userDateOfBirth = "user_date_of_birth"
        case userImageLocalPath = "user_image_local_path"
        case userImageURL = "user_image_url"
        case userCreatedAt = "user_created_at"
        case userUpdatedAt = "user_updated_at"

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
