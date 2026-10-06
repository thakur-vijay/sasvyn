//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVSyncKit

final class SkillsLocalDataSource: SyncLocalStore, @unchecked Sendable{
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [SkillRecord]{
        return try await database.read { database in
           try database.fetchAll(SkillRecord.self)
        }
    }
    
    func fetch() async throws -> [LocalEntitySnapshot<Skill>] {
        try await database.read { db in
            let records = try db.fetch(
                SkillWithMetadataRecord.self,
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

                ORDER BY s.updated_at DESC
                """,
                arguments: [
                    .text(SyncEntityType.skill.rawValue)
                ]
            )
            return records.compactMap(Self.map)
        }
    }
    
    func fetch(id: String) async throws -> SVSyncKit.LocalEntitySnapshot<Skill>? {
        try await database.read { database in

            guard let record = try database.fetchOne(
                SkillWithMetadataRecord.self,
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

            return Self.map(record)
        }
    }
    
    func create(_ entity: Skill) async throws {
        try await database.write { db in
            let record = SkillRecord(
                id: entity.id,
                skill: entity.skill,
                category: entity.category.rawValue,
                createdAt: .now,
                updatedAt: .now
            )
            try db.insert(record)
        }
    }
    
    func update(_ entity: Skill) async throws {
        try await database.write { db in
            try db.update(
                table: SkillRecord.databaseTableName,
                values: [
                    SkillRecord.ColumnNames.skill: .text(entity.skill),
                    SkillRecord.ColumnNames.category: .text(entity.category.rawValue),
                    SkillRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: SkillRecord.ColumnNames.id,
                equals: .text(entity.id)
            )
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(SkillRecord.self, key: id)
        }
    }
    
    private static func map(
        _ record: SkillWithMetadataRecord
    ) -> LocalEntitySnapshot<Skill>? {

        let skillRecord = SkillRecord(
            id: record.id,
            skill: record.skill,
            category: record.category,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
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

        let socialLink = SkillRecordMapper.map(
            skillRecord,
            metadata: metadata
        )

        return LocalEntitySnapshot(
            entity: socialLink,
            metadata: metadata
        )
    }

}
