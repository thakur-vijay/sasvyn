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

    func metadata(id: String) async throws -> SyncMetadata<String>? {
        guard let record = try await fetchRecord(id: id) else { return nil }
        let state: SyncState
        switch record.syncStatus {
        case .synced:
            state = .synced(version: UserRecordMapper.map(record).syncVersion)
        case .pending:
            state = .pending
        case .failed:
            state = .failed(message: "profile synchronization failed")
        case .syncing:
            state = .syncing
        }
        return SyncMetadata(id: id, state: state, lastSyncedAt: record.syncedAt)
    }

    func saveMetadata(_ metadata: SyncMetadata<String>) async throws {
        let status: SyncStatus?
        switch metadata.state {
        case .pending, .syncing:
            status = .pending
        case .failed:
            status = .failed
        case .synced, .idle:
            status = .synced
        }
        guard let status else { return }
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.syncStatus: .text(status.rawValue),
                    UserRecord.ColumnNames.syncedAt: metadata.lastSyncedAt.map { .date($0) } ?? .null,
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(metadata.id)
            )
        }
    }

    func deleteMetadata(id: String) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.syncedAt: .null,
                    UserRecord.ColumnNames.syncError: .null,
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }

    func fetchPendingChanges() async throws -> [SyncPendingChange<String>] {
        let records = try await database.read { db in
            try db.fetchAll(
                UserRecord.self,
                filters: [.equals(
                    UserRecord.ColumnNames.syncStatus,
                    .text(SyncStatus.pending.rawValue)
                )]
            )
        }
        return records.map { record in
            let operation: SyncOperation = .init(rawValue: record.syncOperation ?? "") ?? .create
            let operationID = SyncOperationID(value: record.syncOperationID ?? UUID().uuidString)
            return SyncPendingChange(
                id: record.id,
                context: SyncOperationContext(
                    operationID: operationID,
                    operation: operation
                ),
                retryCount: record.syncRetryCount
            )
        }
    }

    func enqueue(_ change: SyncPendingChange<String>) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.syncStatus: .text(SyncStatus.pending.rawValue),
                    UserRecord.ColumnNames.syncOperationID: .text(change.context.operationID.value),
                    UserRecord.ColumnNames.syncOperation: .text(change.context.operation.rawValue),
                    UserRecord.ColumnNames.syncRetryCount: .integer(change.retryCount),
                    UserRecord.ColumnNames.syncError: .null,
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(change.id)
            )
        }
    }

    func pendingChange(id: String) async throws -> SyncPendingChange<String>? {
        guard let record = try await fetchRecord(id: id),
              record.syncStatus == .pending else {
            return nil
        }

        let operation: SyncOperation = .init(rawValue: record.syncOperation ?? "") ?? .create
        let change = SyncPendingChange(
            id: id,
            context: SyncOperationContext(
                operationID: SyncOperationID(value: record.syncOperationID ?? UUID().uuidString),
                operation: operation
            ),
            retryCount: record.syncRetryCount
        )

        if record.syncOperationID == nil {
            try await enqueue(change)
        }
        return change
    }

    func removePendingChange(id: String) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.syncStatus: .text(SyncStatus.synced.rawValue),
                    UserRecord.ColumnNames.syncOperationID: .null,
                    UserRecord.ColumnNames.syncOperation: .null,
                    UserRecord.ColumnNames.syncRetryCount: .integer(0),
                    UserRecord.ColumnNames.syncError: .null,
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }

    func incrementRetryCount(id: String) async throws {
        guard let record = try await fetchRecord(id: id) else { return }
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.syncRetryCount: .integer(record.syncRetryCount + 1)],
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
        return UserRecordMapper.map(record)
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
                    syncStatus: .synced,
                    createdAt: .now,
                    updatedAt: entity.updatedAt,
                    serverVersion: entity.serverVersion,
                    syncedAt: .now,
                    syncOperationID: nil,
                    syncOperation: nil,
                    syncRetryCount: 0,
                    syncError: nil
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
                    UserRecord.ColumnNames.serverVersion: .integer(Int(entity.serverVersion)),
                    UserRecord.ColumnNames.updatedAt: .date(entity.updatedAt),
                    UserRecord.ColumnNames.syncedAt: .date(.now),
                    UserRecord.ColumnNames.syncError: .null
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

//    func updateAndSync(_ entity: User) async throws {
//        try await database.write { db in
//            let record = try db.fetchOne(
//                UserRecord.self,
//                filters: [
//                    .equals(
//                        UserRecord.ColumnNames.id,
//                        .text(entity.id)
//                    )
//                ]
//            )
//
//            let imageLocalPath: String?
//            if let imageLocalUrl = entity.imageLocalUrl {
//                imageLocalPath = try UserImageStorage.relativePath(
//                    for: imageLocalUrl
//                )
//            } else {
//                imageLocalPath = nil
//            }
//            try db.update(
//                table: UserRecord.databaseTableName,
//                values: [
//                    UserRecord.ColumnNames.fullName: .text(entity.fullName),
//                    UserRecord.ColumnNames.dateOfBirth: .date(entity.dateOfBirth ?? .now),
//                    UserRecord.ColumnNames.imageLocalPath: .text(imageLocalPath ?? ""),
//                    UserRecord.ColumnNames.imageUrl: .text(entity.imageUrl ?? ""),
//                    UserRecord.ColumnNames.syncStatus: .text(SyncStatus.synced.rawValue),
//                    UserRecord.ColumnNames.serverVersion: .integer(Int(entity.serverVersion)),
//                    UserRecord.ColumnNames.updatedAt: .date(entity.updatedAt),
//                    UserRecord.ColumnNames.syncedAt: .date(.now),
//                    UserRecord.ColumnNames.syncError: .null
//                ],
//                whereColumn: UserRecord.ColumnNames.id,
//                equals: .text(entity.id)
//            )
//        }
//    }
    
    func markPending(id: String) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.syncStatus: .text(SyncStatus.pending.rawValue)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }
    
    func markSyncing(id: String) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.syncStatus: .text(SyncStatus.syncing.rawValue)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }
    
    func markSynced(id: String, version: Int64) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.syncStatus: .text(SyncStatus.synced.rawValue)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }
    
    func markFailed(id: String, error: any Error) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.syncStatus: .text(SyncStatus.failed.rawValue)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }
}
