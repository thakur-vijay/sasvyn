//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

public struct SyncMetadataRecord: Codable, SVFetchableRecord, SVPersistableRecord {

    public static let databaseTableName: String = "sync_metadata"

    public let id: String
    public let entityType: String
    public let entityID: String
    public let syncStatus: SyncStatus
    public let serverVersion: Int64
    public let syncedAt: Date?
    public let syncOperationID: String?
    public let syncOperation: String?
    public let syncRetryCount: Int
    public let syncError: String?

    public enum CodingKeys: String, CodingKey {

        case id
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

public extension SyncMetadataRecord {

    nonisolated enum ColumnNames {

        public static let id = SVColumnName("id")
        public static let entityType = SVColumnName("entity_type")
        public static let entityID = SVColumnName("entity_id")

        public static let syncStatus = SVColumnName("sync_status")
        public static let serverVersion = SVColumnName("server_version")
        public static let syncedAt = SVColumnName("synced_at")
        public static let syncOperationID = SVColumnName("sync_operation_id")
        public static let syncOperation = SVColumnName("sync_operation")
        public static let syncRetryCount = SVColumnName("sync_retry_count")
        public static let syncError = SVColumnName("sync_error")
    }
}

public extension SyncMetadataRecord {

    nonisolated enum Columns {

        public static let id = SVColumn("id")
        public static let entityType = SVColumn("entity_type")
        public static let entityID = SVColumn("entity_id")

        public static let syncStatus = SVColumn("sync_status")
        public static let serverVersion = SVColumn("server_version")
        public static let syncedAt = SVColumn("synced_at")
        public static let syncOperationID = SVColumn("sync_operation_id")
        public static let syncOperation = SVColumn("sync_operation")
        public static let syncRetryCount = SVColumn("sync_retry_count")
        public static let syncError = SVColumn("sync_error")
    }
}
