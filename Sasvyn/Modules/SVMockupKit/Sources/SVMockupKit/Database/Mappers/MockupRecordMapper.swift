//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum MockupRecordMapper {

    nonisolated static func map(
        _ record: MockupRecord,
        mockupsDirectory: URL
    ) -> MockupModel? {

        let url = mockupsDirectory
            .appendingPathComponent(record.path)
        let thumbnail = mockupsDirectory.appendingPathComponent(record.thumbnailPath)

        return MockupModel(
            id: record.id,
            url: url,
            thumbnail: thumbnail,
            size: record.fileSize,
            aspectRatio: record.aspectRatio,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }
}

