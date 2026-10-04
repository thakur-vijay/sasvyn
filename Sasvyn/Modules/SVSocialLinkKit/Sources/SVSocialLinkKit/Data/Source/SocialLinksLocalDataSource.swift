//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVDatabaseKit
import SVSyncKit
import SVFoundation

final class SocialLinksLocalDataSource: SyncLocalStore, @unchecked Sendable {

    private let database: AppDatabase

    init(database: AppDatabase) {
        self.database = database
    }

    // MARK: - Fetch
    
    func fetch() async throws -> [LocalEntitySnapshot<SocialLink>] {
        try await database.read { database in

            let records = try database.fetch(
                SocialLinkWithMetadataRecord.self,
                sql: """
                SELECT
                    sl.id         AS social_link_id,
                    sl.type       AS social_link_type,
                    sl.url        AS social_link_url,
                    sl.created_at AS social_link_created_at,
                    sl.updated_at AS social_link_updated_at,

                    sm.id                AS metadata_id,
                    sm.entity_type       AS entity_type,
                    sm.entity_id         AS entity_id,
                    sm.sync_status       AS sync_status,
                    sm.server_version    AS server_version,
                    sm.synced_at         AS synced_at,
                    sm.sync_operation_id AS sync_operation_id,
                    sm.sync_operation    AS sync_operation,
                    sm.sync_retry_count  AS sync_retry_count,
                    sm.sync_error        AS sync_error

                FROM social_links sl

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = sl.id
                    AND sm.entity_type = ?

                ORDER BY sl.updated_at DESC
                """,
                arguments: [
                    .text(SyncEntityType.socialLink.rawValue)
                ]
            )

            return records.compactMap(Self.map)
        }
    }

    func fetch(id: String) async throws -> LocalEntitySnapshot<SocialLink>? {
        try await database.read { database in

            guard let record = try database.fetchOne(
                SocialLinkWithMetadataRecord.self,
                sql: """
                SELECT
                    sl.id         AS social_link_id,
                    sl.type       AS social_link_type,
                    sl.url        AS social_link_url,
                    sl.created_at AS social_link_created_at,
                    sl.updated_at AS social_link_updated_at,

                    sm.id                AS metadata_id,
                    sm.entity_type       AS entity_type,
                    sm.entity_id         AS entity_id,
                    sm.sync_status       AS sync_status,
                    sm.server_version    AS server_version,
                    sm.synced_at         AS synced_at,
                    sm.sync_operation_id AS sync_operation_id,
                    sm.sync_operation    AS sync_operation,
                    sm.sync_retry_count  AS sync_retry_count,
                    sm.sync_error        AS sync_error

                FROM social_links sl

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = sl.id
                    AND sm.entity_type = ?

                WHERE sl.id = ?
                """,
                arguments: [
                    .text(SyncEntityType.socialLink.rawValue),
                    .text(id)
                ]
            ) else {
                return nil
            }

            return Self.map(record)
        }
    }

    // MARK: - Local Entity

    func create(_ link: SocialLink) async throws {
        try await database.write { db in
            let record = SocialLinkRecord(
                id: link.id,
                type: link.type?.rawValue ?? "",
                url: link.url?.absoluteString ?? "",
                createdAt: .now,
                updatedAt: .now
            )

            try db.insert(record)
        }
    }

    func update(_ link: SocialLink) async throws {
        try await database.write { db in
            try db.update(
                table: SocialLinkRecord.databaseTableName,
                values: [
                    SocialLinkRecord.ColumnNames.type:
                        .text(link.type?.rawValue ?? ""),

                    SocialLinkRecord.ColumnNames.url:
                        .text(link.url?.absoluteString ?? ""),

                    SocialLinkRecord.ColumnNames.updatedAt:
                        .date(.now)
                ],
                whereColumn: SocialLinkRecord.ColumnNames.id,
                equals: .text(link.id)
            )
        }
    }

    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(
                SocialLinkRecord.self,
                key: id
            )
        }
    }

    // MARK: - Metadata

    func metadata(id: String) async throws -> SyncMetadata? {
        try await database.read { db in
            guard let record = try db.fetchOne(
                SyncMetadataRecord.self,
                filters: [
                    .equals(
                        SyncMetadataRecord.ColumnNames.entityID,
                        .text(id)
                    )
                ]
            ) else {
                return nil
            }

            return SyncMetadataRecordMapper.map(record)
        }
    }

    func saveMetadata(_ metadata: SyncMetadata) async throws {
        dump(metadata)
        try await database.write { db in

            let record = SyncMetadataRecord(
                id: IDGenerator.uuid(),
                entityType: metadata.entityType,
                entityID: metadata.id,
                syncStatus: self.status(from: metadata.state),
                serverVersion: metadata.serverVersion,
                syncedAt: metadata.lastSyncedAt,
                syncOperationID: metadata.operationID,
                syncOperation: metadata.operation,
                syncRetryCount: metadata.retryCount,
                syncError: metadata.lastError
            )

            print("INSERT OPERATION ID:", record.syncOperationID as Any)
            try db.insert(record)
            
            let value = try db.fetchOne(SyncMetadataRecord.self, filters: [.equals(SyncMetadataRecord.ColumnNames.entityID, .text(metadata.id))])
            print("DB OPERATION ID:", value?.syncOperationID as Any)
        }
    }

    func deleteMetadata(id: String) async throws {
        try await database.write { db in
            try db.delete(
                SyncMetadataRecord.self,
                where: .equals(
                    SyncMetadataRecord.ColumnNames.entityID,
                    .text(id)
                )
            )
        }
    }
    
    func fetchMetadata() async throws -> [SyncMetadata] {
        try await database.read { db in
            let records = try db.fetchAll(
                SyncMetadataRecord.self,
                filters: [.equals(
                    SyncMetadataRecord.ColumnNames.entityType,
                    .text(SyncEntityType.socialLink.rawValue)
                )],
            )
            return records.map(SyncMetadataRecordMapper.map)
        }
    }

    func fetchPendingMetadata() async throws -> [SyncMetadata] {
        try await database.read { db in

            let records = try db.fetchAll(
                SyncMetadataRecord.self,
                filters: [
                    .equals(
                        SyncMetadataRecord.ColumnNames.syncStatus,
                        .text(SyncStatus.pending.rawValue)
                    )
                ]
            )

            return records.map(SyncMetadataRecordMapper.map)
        }
    }

    func markPending(
        id: String,
        operation: SyncOperation,
        operationID: String
    ) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncStatus:
                        .text(SyncStatus.pending.rawValue),

                    SyncMetadataRecord.ColumnNames.syncOperationID:
                        .text(operationID),

                    SyncMetadataRecord.ColumnNames.syncOperation:
                        .text(operation.rawValue),

                    SyncMetadataRecord.ColumnNames.syncError:
                        .null,

                    SyncMetadataRecord.ColumnNames.syncRetryCount:
                        .integer(0)
                ],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    func markSyncing(id: String) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncStatus:
                        .text(SyncStatus.syncing.rawValue)
                ],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    func markSynced(
        id: String,
        version: Int64
    ) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncStatus:
                        .text(SyncStatus.synced.rawValue),

                    SyncMetadataRecord.ColumnNames.serverVersion:
                        .integer(Int(version)),

                    SyncMetadataRecord.ColumnNames.syncedAt:
                        .date(.now),

                    SyncMetadataRecord.ColumnNames.syncOperationID:
                        .null,

                    SyncMetadataRecord.ColumnNames.syncOperation:
                        .null,

                    SyncMetadataRecord.ColumnNames.syncRetryCount:
                        .integer(0),

                    SyncMetadataRecord.ColumnNames.syncError:
                        .null
                ],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    func markFailed(
        id: String,
        error: String
    ) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncStatus:
                        .text(SyncStatus.failed.rawValue),

                    SyncMetadataRecord.ColumnNames.syncError:
                        .text(error)
                ],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    func incrementRetryCount(id: String) async throws {
        try await database.write { db in

            guard let metadata = try db.fetchOne(
                SyncMetadataRecord.self,
                filters: [
                    .equals(
                        SyncMetadataRecord.ColumnNames.entityID,
                        .text(id)
                    )
                ]
            ) else {
                throw SyncError.metadataNotFound
            }

            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncRetryCount:
                        .integer(metadata.syncRetryCount + 1)
                ],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    // MARK: - Mapping

    private static func map(
        _ record: SocialLinkWithMetadataRecord
    ) -> LocalEntitySnapshot<SocialLink>? {

        let socialLinkRecord = SocialLinkRecord(
            id: record.socialLinkID,
            type: record.socialLinkType,
            url: record.socialLinkURL,
            createdAt: record.socialLinkCreatedAt,
            updatedAt: record.socialLinkUpdatedAt
        )

        let metadata: SyncMetadata? = {
            guard let metadataID = record.metadataID,
                  let entityType = record.entityType,
                  let entityID = record.entityID,
                  let syncStatus = record.syncStatus,
                  let serverVersion = record.serverVersion
            else {
                return nil
            }

            let metadataRecord = SyncMetadataRecord(
                id: metadataID,
                entityType: entityType,
                entityID: entityID,
                syncStatus: syncStatus,
                serverVersion: serverVersion,
                syncedAt: record.syncedAt,
                syncOperationID: record.syncOperationID,
                syncOperation: record.syncOperation,
                syncRetryCount: record.syncRetryCount ?? 0,
                syncError: record.syncError
            )

            return SyncMetadataRecordMapper.map(metadataRecord)
        }()

        let socialLink = SocialLinkRecordMapper.map(
            socialLinkRecord,
            metadata: metadata
        )

        return LocalEntitySnapshot(
            entity: socialLink,
            metadata: metadata
        )
    }

    private func status(
        from state: SyncState
    ) -> SyncStatus {
        switch state {
        case .idle:
            return .idle
        case .pending:
            return .pending
        case .syncing:
            return .syncing
        case .synced:
            return .synced
        case .failed:
            return .failed
        }
    }
}
