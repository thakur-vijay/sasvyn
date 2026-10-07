//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVSyncKit

final class DocumentsLocalDataSource: SyncLocalStore, @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [LocalEntitySnapshot<Document>] {
        try await database.read { db in
            let records = try db.fetch(
                DocumentWithMetadataRecord.self,
                sql: """
                SELECT
                    d.id         AS document_id,
                    d.name       AS document_name,
                    d.path       AS document_path,
                    d.category   AS document_category,
                    d.file_size  AS document_file_size,
                    d.created_at AS document_created_at,
                    d.updated_at AS document_updated_at,

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

                FROM documents d

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = d.id
                    AND sm.entity_type = ?

                ORDER BY d.updated_at DESC
                """,
                arguments: [
                    .text(SyncEntityType.document.rawValue)
                ]
            )

            let directory = try DocumentStorage.documentsDirectory()

            return records.compactMap { record in
                Self.map(
                    record,
                    documentDirectoryURL: directory
                )
            }
        }
    }

    
    func fetch(id: String) async throws -> SVSyncKit.LocalEntitySnapshot<Document>? {
        try await database.read { database in

            guard let record = try database.fetchOne(
                DocumentWithMetadataRecord.self,
                sql: """
                SELECT
                    s.id         AS id,
                    s.skill      AS skill,
                    s.category   AS category,
                    s.created_at AS created_at,
                    s.updated_at AS updated_at,

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

                FROM skills s

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = s.id
                    AND sm.entity_type = ?

                WHERE s.id = ?
                """,
                arguments: [
                    .text(SyncEntityType.skill.rawValue),
                    .text(id)
                ]
            ) else {
                return nil
            }
            let directory = try DocumentStorage.documentsDirectory()
            return Self.map(record, documentDirectoryURL: directory)
        }
    }
    
    func create(_ entity: Document) async throws {
        try await database.write { db in
            var path: String = ""
            if let url = entity.url {
                path = try DocumentStorage.relativePath(for: url)
            }
            let record = DocumentRecord(
                id: entity.id,
                name: entity.name,
                path: path,
                category: entity.category.rawValue,
                fileSize: entity.fileSize,
                createdAt: entity.createdAt,
                updatedAt: entity.updatedAt
            )
            try db.insert(record)
        }
    }
    
    func update(_ entity: Document) async throws {}
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(DocumentRecord.self, key: id)
        }
    }
    
    private static func map(
        _ record: DocumentWithMetadataRecord,
        documentDirectoryURL: URL
    ) -> LocalEntitySnapshot<Document>? {

        let skillRecord = DocumentRecord(
            id: record.documentID,
            name: record.documentName,
            path: record.documentPath,
            category: record.documentCategory,
            fileSize: record.documentFileSize,
            createdAt: record.documentCreatedAt,
            updatedAt: record.documentUpdatedAt
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

        let document = DocumentRecordMapper.map(
            skillRecord,
            metadata: metadata,
            documentsDirectory: documentDirectoryURL
        )

        return LocalEntitySnapshot(
            entity: document,
            metadata: metadata
        )
    }

}
