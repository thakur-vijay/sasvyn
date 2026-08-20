//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum DocumentRecordMapper {

    nonisolated static func map(
        _ record: DocumentRecord,
        documentsDirectory: URL
    ) -> Document? {

        guard let category = DocumentCategory(
            rawValue: record.category
        ) else {
            return nil
        }

        let url = documentsDirectory
            .appendingPathComponent(record.path)

        return Document(
            id: record.id,
            url: url,
            name: record.name,
            createdAt: record.createdAt,
            fileSize: record.fileSize,
            category: category
        )
    }
}

