//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

public enum SyncMetadataRecordMapper {

    public nonisolated static func map(
        _ record: SyncMetadataRecord
    ) -> SyncMetadata {

        let state: SyncState

        switch record.syncStatus {
        case .pending:
            state = .pending

        case .syncing:
            state = .syncing

        case .synced:
            state = .synced(version: record.serverVersion)

        case .failed:
            state = .failed(
                message: record.syncError ?? "Unknown sync error"
            )
        case .idle:
            state = .idle
        }

        return .init(
            id: record.entityID,
            entityType: record.entityType,
            state: state,
            serverVersion: record.serverVersion,
            lastSyncedAt: record.syncedAt,
            operationID: record.syncOperationID,
            operation: record.syncOperation,
            retryCount: record.syncRetryCount,
            lastError: record.syncError
        )
    }
}
