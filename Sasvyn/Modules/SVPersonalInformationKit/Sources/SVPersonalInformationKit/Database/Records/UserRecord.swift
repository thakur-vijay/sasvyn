//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVNetwork

struct UserRecord: Codable, SVFetchableRecord, SVPersistableRecord {

    static let databaseTableName: String = "users"

    let id: String
    let appleId: String
    let fullName: String
    let email: String
    let dateOfBirth: Date?
    let imageLocalPath: String?
    let imageUrl: String?

    let syncStatus: SyncStatus
    
    let createdAt: Date
    let updatedAt: Date

    let serverVersion: Int64
    let syncedAt: Date?

    let syncOperationID: String?
    let syncOperation: String?
    let syncRetryCount: Int
    let syncError: String?

    enum CodingKeys: String, CodingKey {

        case id
        case appleId = "apple_id"
        case fullName = "full_name"
        case email
        case dateOfBirth = "date_of_birth"
        case imageLocalPath = "image_local_path"
        case imageUrl = "image_url"

        case syncStatus = "sync_status"

        case createdAt = "created_at"
        case updatedAt = "updated_at"

        case serverVersion = "server_version"
        case syncedAt = "synced_at"

        case syncOperationID = "sync_operation_id"
        case syncOperation = "sync_operation"
        case syncRetryCount = "sync_retry_count"
        case syncError = "sync_error"
    }
}

extension UserRecord {

    nonisolated enum ColumnNames {

        static let id = SVColumnName("id")
        static let appleId = SVColumnName("apple_id")
        static let fullName = SVColumnName("full_name")
        static let email = SVColumnName("email")
        static let dateOfBirth = SVColumnName("date_of_birth")
        static let imageLocalPath = SVColumnName("image_local_path")
        static let imageUrl = SVColumnName("image_url")

        static let syncStatus = SVColumnName("sync_status")

        static let createdAt = SVColumnName("created_at")
        static let updatedAt = SVColumnName("updated_at")

        static let serverVersion = SVColumnName("server_version")
        static let syncedAt = SVColumnName("synced_at")

        static let syncOperationID = SVColumnName("sync_operation_id")
        static let syncOperation = SVColumnName("sync_operation")
        static let syncRetryCount = SVColumnName("sync_retry_count")
        static let syncError = SVColumnName("sync_error")
    }
}

extension UserRecord {

    nonisolated enum Columns {

        static let id = SVColumn("id")
        static let appleId = SVColumn("apple_id")
        static let fullName = SVColumn("full_name")
        static let email = SVColumn("email")
        static let dateOfBirth = SVColumn("date_of_birth")
        static let imageLocalPath = SVColumn("image_local_path")
        static let imageUrl = SVColumn("image_url")

        static let syncStatus = SVColumn("sync_status")

        static let createdAt = SVColumn("created_at")
        static let updatedAt = SVColumn("updated_at")

        static let serverVersion = SVColumn("server_version")
        static let syncedAt = SVColumn("synced_at")

        static let syncOperationID = SVColumn("sync_operation_id")
        static let syncOperation = SVColumn("sync_operation")
        static let syncRetryCount = SVColumn("sync_retry_count")
        static let syncError = SVColumn("sync_error")
    }
}
