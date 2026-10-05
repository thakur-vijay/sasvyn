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

internal final class LanguagesLocalDataSource: SyncLocalStore, @unchecked Sendable {

    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func loadLanguagesJSON() async throws -> [Language] {
        guard let url = Bundle.module.url(
            forResource: "Languages",
            withExtension: "json"
        ) else {
            throw LanguagesLocalDataSourceError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        return try JSONDecoder().decode(
            [Language].self,
            from: data
        )
    }
    
    func fetch() async throws -> [LocalEntitySnapshot<SpokenLanguage>] {
        try await database.read { database in

            let records = try database.fetch(
                LanguageWithMetadataRecord.self,
                sql: """
                SELECT
                    l.id           AS language_id,
                    l.language_code AS language_code,
                    l.language     AS language,
                    l.proficiency  AS proficiency,
                    l.created_at   AS language_created_at,
                    l.updated_at   AS language_updated_at,

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

                FROM spoken_languages l

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = l.id
                    AND sm.entity_type = ?

                ORDER BY l.updated_at DESC
                """,
                arguments: [
                    .text(SyncEntityType.language.rawValue)
                ]
            )

            return records.compactMap(Self.map)
        }
    }
    
    func fetch(id: String) async throws -> LocalEntitySnapshot<SpokenLanguage>? {
        try await database.read { database in

            guard let record = try database.fetchOne(
                LanguageWithMetadataRecord.self,
                sql: """
                SELECT
                    l.id            AS language_id,
                    l.language_code AS language_code,
                    l.language     AS language,
                    l.proficiency  AS proficiency,
                    l.created_at   AS language_created_at,
                    l.updated_at   AS language_updated_at,

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

                FROM spoken_languages l

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = l.id
                    AND sm.entity_type = ?

                WHERE l.id = ?
                """,
                arguments: [
                    .text(SyncEntityType.language.rawValue),
                    .text(id)
                ]
            ) else {
                return nil
            }

            return Self.map(record)
        }
    }

    
    func create(_ entity: SpokenLanguage) async throws {
        try await database.write { db in
            let record = SpokenLanguageRecord(
                id: entity.id,
                languageCode: entity.languageCode,
                language: entity.language,
                proficiency: Int(entity.proficiency.rawValue),
                createdAt: .now,
                updatedAt: .now
            )

            try db.insert(record)
        }
    }
    
    func update(_ entity: SpokenLanguage) async throws {
        try await database.write { db in
            try db.update(
                table: SpokenLanguageRecord.databaseTableName,
                values: [
                    SpokenLanguageRecord.ColumnNames.language: .text(entity.language),
                    SpokenLanguageRecord.ColumnNames.proficiency: .integer(Int(entity.proficiency.rawValue)),
                    SpokenLanguageRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: SpokenLanguageRecord.ColumnNames.languageCode,
                equals: .text(entity.languageCode)
            )
        }

    }
        
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(SpokenLanguageRecord.self, key: id)
        }
    }
    
    private static func map(
        _ record: LanguageWithMetadataRecord
    ) -> LocalEntitySnapshot<SpokenLanguage>? {

        let languageRecord = SpokenLanguageRecord(
            id: record.languageID,
            languageCode: record.languageCode,
            language: record.language,
            proficiency: record.proficiency,
            createdAt: record.languageCreatedAt,
            updatedAt: record.languageUpdatedAt
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

        let socialLink = SpokenLanguageRecordMapper.map(
            languageRecord,
            metadata: metadata
        )

        return LocalEntitySnapshot(
            entity: socialLink,
            metadata: metadata
        )
    }

}

enum LanguagesLocalDataSourceError: Error {
    case fileNotFound
}
