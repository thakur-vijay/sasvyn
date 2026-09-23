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

    func save(_ entity: User) async throws {
        try await save(user: entity)
    }
    
    func save(
        user: User,
        profileSyncStatus: SyncStatus? = nil,
        imageSyncStatus: SyncStatus? = nil,
        syncedAt: Date? = nil
    ) async throws {
        try await database.write { db in
            let record = try db.fetchOne(UserRecord.self, filters: [.equals(UserRecord.ColumnNames.id, .text(user.id))])
            var imageLocalPath: String?
            if let imageLocalUrl = user.imageLocalUrl{
                imageLocalPath = try UserImageStorage.relativePath(for: imageLocalUrl)
            }
            
            if let record {
                try db.update(
                    table: UserRecord.databaseTableName,
                    values: [
                        UserRecord.ColumnNames.fullName: .text(user.fullName),
                        UserRecord.ColumnNames.dateOfBirth: .date(user.dateOfBirth ?? .now),
                        UserRecord.ColumnNames.imageLocalPath: .text(imageLocalPath ?? ""),
                        UserRecord.ColumnNames.imageUrl: .text(user.imageUrl ?? ""),
                        UserRecord.ColumnNames.profileSyncStatus: .text(
                            profileSyncStatus?.rawValue ?? record.profileSyncStatus.rawValue
                        ),
                        UserRecord.ColumnNames.imageSyncStatus: .text(
                            imageSyncStatus?.rawValue ?? record.imageSyncStatus.rawValue
                        ),
                        UserRecord.ColumnNames.serverVersion: .integer(Int(user.serverVersion)),
                        UserRecord.ColumnNames.updatedAt: .date(user.updatedAt),
                    ],
                    whereColumn: UserRecord.ColumnNames.id,
                    equals: .text(user.id)
                )
            }else {
                //create
                try db.insert(
                    UserRecord(
                        id: user.id,
                        appleId: user.appleId,
                        fullName: user.fullName,
                        email: user.email,
                        dateOfBirth: user.dateOfBirth,
                        imageLocalPath: imageLocalPath,
                        imageUrl: user.imageUrl,
                        profileSyncStatus: profileSyncStatus ?? .synced,
                        imageSyncStatus: imageSyncStatus ?? .synced,
                        createdAt: .now,
                        updatedAt: .now,
                        serverVersion: user.serverVersion,
                        syncedAt: syncedAt,
                        syncOperationID: nil,
                        syncOperation: nil,
                        syncRetryCount: 0,
                        syncError: nil
                    )
                )
            }
        }
    }
    
    func updateSyncedAt(id: String, syncedAt: Date) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.syncedAt: .date(syncedAt),
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
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

    func metadata(id: String) async throws -> SyncMetadata<String>? {
        guard let record = try await fetchRecord(id: id) else { return nil }
        let state: SyncState
        switch record.profileSyncStatus {
        case .synced:
            state = .synced(version: UserRecordMapper.map(record).syncVersion)
        case .pending:
            state = .pending
        case .failed:
            state = .failed(message: "profile synchronization failed")
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
                    UserRecord.ColumnNames.profileSyncStatus: .text(status.rawValue),
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
                    UserRecord.ColumnNames.profileSyncStatus,
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
                    UserRecord.ColumnNames.profileSyncStatus: .text(SyncStatus.pending.rawValue),
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
              record.profileSyncStatus == .pending else {
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

    func markPendingUpload(id: String) async throws {
        try await setProfileStatus(id: id, status: .pending)
    }

    func markSyncing(id: String) async throws {
        try await setProfileStatus(id: id, status: .pending)
    }

    func markSynced(id: String, version: Int64) async throws {
        try await setProfileStatus(id: id, status: .synced)
        try await updateSyncedAt(id: id, syncedAt: .now)
    }

    func markFailed(id: String, error: Error) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [
                    UserRecord.ColumnNames.profileSyncStatus: .text(SyncStatus.failed.rawValue),
                    UserRecord.ColumnNames.syncError: .text(String(describing: error)),
                ],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }

    private func setProfileStatus(id: String, status: SyncStatus) async throws {
        try await database.write { db in
            try db.update(
                table: UserRecord.databaseTableName,
                values: [UserRecord.ColumnNames.profileSyncStatus: .text(status.rawValue)],
                whereColumn: UserRecord.ColumnNames.id,
                equals: .text(id)
            )
        }
    }
    
}
