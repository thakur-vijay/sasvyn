//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVNetwork

final class UsersLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch(id: String) async throws -> UserRecord? {
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
                        UserRecord.ColumnNames.updatedAt: .date(.now),
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
                        syncedAt: syncedAt
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
    
}
