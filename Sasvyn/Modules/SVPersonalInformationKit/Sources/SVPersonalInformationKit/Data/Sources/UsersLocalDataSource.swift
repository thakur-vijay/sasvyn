//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVNetwork
import SVSyncKit
import SVFoundation

final class UsersLocalDataSource: SyncLocalStore, @unchecked Sendable{
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetchRecord(id: String) async throws -> UserRecord? {
        return try await database.read { database in
            try database.fetchOne(
                UserRecord.self,
                filters: [.equals(
                    UserRecord.ColumnNames.id,
                    .text(
                        id
                    )
                )]
            )
        }
    }
    
    func fetch() async throws -> [LocalEntitySnapshot<User>] {
        return []
    }
    
    func fetch(id: String) async throws -> LocalEntitySnapshot<User>? {
        try await database.read { database in
            guard let record = try database.fetchOne(
                UserWithMetadataRecord.self,
                sql: """
                SELECT
                    u.id               AS user_id,
                    u.apple_id         AS user_apple_id,
                    u.full_name        AS user_full_name,
                    u.email            AS user_email,
                    u.date_of_birth    AS user_date_of_birth,
                    u.image_local_path AS user_image_local_path,
                    u.image_url        AS user_image_url,
                    u.created_at       AS user_created_at,
                    u.updated_at       AS user_updated_at,

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

                FROM users u

                LEFT JOIN sync_metadata sm
                    ON sm.entity_id = u.id
                    AND sm.entity_type = ?

                WHERE u.id = ?
                """,
                arguments: [
                    .text(SyncEntityType.user.rawValue),
                    .text(id)
                ]
            ) else {
                return nil
            }

            let userRecord = UserRecord(
                id: record.userID,
                appleId: record.userAppleID,
                fullName: record.userFullName,
                email: record.userEmail,
                dateOfBirth: record.userDateOfBirth,
                imageLocalPath: record.userImageLocalPath,
                imageUrl: record.userImageURL,
                createdAt: record.userCreatedAt,
                updatedAt: record.userUpdatedAt
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

            return LocalEntitySnapshot(
                entity: UserRecordMapper.map(userRecord, metadata),
                metadata: metadata
            )
        }
    }
    
    func create(_ entity: User) async throws {
        try await database.write { db in
            try db.insert(
                UserRecord(
                    id: entity.id,
                    appleId: entity.appleId,
                    fullName: entity.fullName,
                    email: entity.email,
                    dateOfBirth: entity.dateOfBirth,
                    imageLocalPath: nil,
                    imageUrl: entity.imageUrl,
                    createdAt: .now,
                    updatedAt: entity.updatedAt,
                )
            )
        }
    }
    
    func update(_ entity: User) async throws {
        try await database.write { db in
            let imageLocalPath: String?
            if let imageLocalUrl = entity.imageLocalUrl {
                imageLocalPath = try UserImageStorage.relativePath(
                    for: imageLocalUrl
                )
            } else {
                imageLocalPath = nil
            }
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.fullName: .text(entity.fullName),
                    UserRecord.ColumnNames.dateOfBirth: .date(entity.dateOfBirth ?? .now),
                    UserRecord.ColumnNames.imageLocalPath: .text(imageLocalPath ?? ""),
                    UserRecord.ColumnNames.imageUrl: .text(entity.imageUrl ?? ""),
                    UserRecord.ColumnNames.updatedAt: .date(entity.updatedAt),
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(entity.id)
            )
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(
                UserRecord.self,
                key: id
            )
        }
    }
}
