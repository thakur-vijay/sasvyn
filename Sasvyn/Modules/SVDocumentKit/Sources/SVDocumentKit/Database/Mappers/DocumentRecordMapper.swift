//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation
import SVSyncKit

enum DocumentRecordMapper {

    nonisolated static func map(
        _ record: DocumentRecord,
        metadata: SyncMetadata?,
        documentsDirectory: URL
    ) -> Document {
        let url = documentsDirectory
            .appendingPathComponent(record.path)

        return Document(
            id: record.id,
            localUrl: url,
            url: nil,
            name: record.name,
            createdAt: record.createdAt,
            fileSize: record.fileSize,
            category: DocumentCategory(rawValue: record.category) ?? .other,
            syncVersion: metadata?.serverVersion ?? 1,
            updatedAt: record.updatedAt
        )
    }
}

