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

final class UsersLocalDataSource: SyncLocalStore, @unchecked Sendable{
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }

    func metadata(id: String) async throws -> SyncMetadata?{
        try await database.read { db in
            guard let record = try db.fetchOne(
                SyncMetadataRecord.self,
                filters: [.equals(
                    SyncMetadataRecord.ColumnNames.entityID,
                    .text(id)
                )]
            ) else { throw URLError(.dataNotAllowed)}
            return SyncMetadataRecordMapper.map(record)
        }
    }

    func saveMetadata(_ metadata: SyncMetadata) async throws {
        let status: SyncStatus

        switch metadata.state {
        case .pending:
            status = .pending
        case .syncing:
            status = .syncing
        case .failed:
            status = .failed
        case .synced:
            status = .synced
        case .idle:
            status = .idle
        }

        try await database.write { db in

            let existing = try db.fetchOne(
                SyncMetadataRecord.self,
                filters: [
                    .equals(
                        SyncMetadataRecord.ColumnNames.entityID,
                        .text(metadata.id)
                    )
                ]
            )

            let values: [SVColumnName: SVDatabaseValue] = [
                SyncMetadataRecord.ColumnNames.entityType:
                    .text(metadata.entityType),

                SyncMetadataRecord.ColumnNames.syncStatus:
                    .text(status.rawValue),

                SyncMetadataRecord.ColumnNames.serverVersion:
                        .integer(Int(metadata.serverVersion)),

                SyncMetadataRecord.ColumnNames.syncedAt:
                    metadata.lastSyncedAt.map { .date($0) } ?? .null,

                SyncMetadataRecord.ColumnNames.syncOperationID:
                    metadata.operationID.map { .text($0) } ?? .null,

                SyncMetadataRecord.ColumnNames.syncOperation:
                    metadata.operation.map { .text($0) } ?? .null,

                SyncMetadataRecord.ColumnNames.syncRetryCount:
                    .integer(metadata.retryCount),

                SyncMetadataRecord.ColumnNames.syncError:
                    metadata.lastError.map { .text($0) } ?? .null
            ]

            if existing != nil {

                try db.update(
                    table: SyncMetadataRecord.databaseTableName,
                    values: values,
                    whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                    equals: .text(metadata.id)
                )

            } else {

                var insertValues = values

                insertValues[SyncMetadataRecord.ColumnNames.id] =
                    .text(UUID().uuidString)

                insertValues[SyncMetadataRecord.ColumnNames.entityID] =
                    .text(metadata.id)
                try db.insert(
                    into: SyncMetadataRecord.databaseTableName,
                    values: insertValues
                )
            }
        }
    }

    func deleteMetadata(id: String) async throws {
        try await database.write { db in
            try db.delete(
                SyncMetadataRecord.self,
                where: .equals(
                    SyncMetadataRecord.ColumnNames.entityID,
                    .text(
                        id
                    )
                )
            )
        }
    }
    
    func fetchPendingMetadata() async throws -> [SyncMetadata] {
        try await database.read { db in
           let records = try db.fetchAll(
                SyncMetadataRecord.self,
                filters: [.equals(
                    SyncMetadataRecord.ColumnNames.syncStatus,
                    .text(SyncStatus.pending.rawValue)
                )],
            )
            return records.map { SyncMetadataRecordMapper.map($0)}
        }
    }
    
    func markPending(
        id: String,
        operation: SyncOperation
    ) async throws {

        try await database.write { db in

            guard let existing = try db.fetchOne(
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

            let operationID =
                existing.syncOperationID
                ?? UUID().uuidString

            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncStatus:
                        .text(SyncStatus.pending.rawValue),

                    SyncMetadataRecord.ColumnNames.syncOperation:
                        .text(operation.rawValue),

                    SyncMetadataRecord.ColumnNames.syncOperationID:
                        .text(operationID),

                    SyncMetadataRecord.ColumnNames.syncError:
                        .null
                ],
                whereColumn:
                    SyncMetadataRecord.ColumnNames.entityID,
                equals:
                    .text(id)
            )
        }
    }
    
    func markFailed(id: String, error: String) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [
                    SyncMetadataRecord.ColumnNames.syncError: .text(error),
                    SyncMetadataRecord.ColumnNames.syncStatus: .text(SyncStatus.failed.rawValue),
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
                values: [SyncMetadataRecord.ColumnNames.syncStatus: .text(SyncStatus.syncing.rawValue)],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }
    
    func markSynced(id: String, version: Int64) async throws {
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [SyncMetadataRecord.ColumnNames.syncStatus: .text(SyncStatus.synced.rawValue)],
                whereColumn: SyncMetadataRecord.ColumnNames.entityID,
                equals: .text(id)
            )
        }
    }

    func incrementRetryCount(id: String) async throws {
        guard let record = try await metadata(id: id) else { return }
        try await database.write { db in
            try db.update(
                table: SyncMetadataRecord.databaseTableName,
                values: [SyncMetadataRecord.ColumnNames.syncRetryCount: .integer(record.retryCount + 1)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
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
    
    func fetch(id: String) async throws -> User? {
        guard let record = try await fetchRecord(id: id) else { return nil }
        guard let metadata = try await metadata(id: id) else { return nil }
        return UserRecordMapper.map(record, metadata)
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
