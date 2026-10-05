//
//  SyncMetadataStore.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation
import SVDatabaseKit
import SVFoundation

public protocol SyncMetadataStore: Sendable {

    func metadata(
        id: String
    ) async throws -> SyncMetadata?

    func saveMetadata(
        _ metadata: SyncMetadata
    ) async throws

    func deleteMetadata(
        id: String
    ) async throws
    
    func fetchMetadata(_ type: SyncEntityType) async throws -> [SyncMetadata]

    func fetchPendingMetadata(_ type: SyncEntityType)
        async throws -> [SyncMetadata]

    func markPending(
        id: String,
        operation: SyncOperation,
        operationID: String
    ) async throws

    func markSyncing(
        id: String
    ) async throws

    func markSynced(
        id: String,
        version: Int64
    ) async throws

    func markFailed(
        id: String,
        error: String
    ) async throws

    func incrementRetryCount(
        id: String
    ) async throws
}

public final class DefaultSyncMetadataStore: SyncMetadataStore{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    public func metadata(id: String) async throws -> SyncMetadata? {
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

    public func saveMetadata(_ metadata: SyncMetadata) async throws {
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

    public func deleteMetadata(id: String) async throws {
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
    
    public func fetchMetadata(_ type: SyncEntityType) async throws -> [SyncMetadata] {
        try await database.read { db in
            let records = try db.fetchAll(
                SyncMetadataRecord.self,
                filters: [.equals(
                    SyncMetadataRecord.ColumnNames.entityType,
                    .text(type.rawValue)
                )],
            )
            return records.map(SyncMetadataRecordMapper.map)
        }
    }

    public func fetchPendingMetadata(_ type: SyncEntityType) async throws -> [SyncMetadata] {
        try await database.read { db in

            let records = try db.fetchAll(
                SyncMetadataRecord.self,
                filters: [
                    .equals(
                        SyncMetadataRecord.ColumnNames.syncStatus,
                        .text(SyncStatus.pending.rawValue)
                    ),
                    .equals(SyncMetadataRecord.ColumnNames.entityType, .text(type.rawValue))
                ]
            )

            return records.map(SyncMetadataRecordMapper.map)
        }
    }

    public func markPending(
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

    public func markSyncing(id: String) async throws {
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

    public func markSynced(
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

    public func markFailed(
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

    public func incrementRetryCount(id: String) async throws {
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
