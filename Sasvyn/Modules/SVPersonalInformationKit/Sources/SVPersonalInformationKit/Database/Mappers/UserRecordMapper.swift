//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation
import SVSyncKit

enum UserRecordMapper {

    nonisolated static func map(
        _ record: UserRecord,
        _ metadata: SyncMetadata?
    ) -> User {
        var localImageUrl: URL?
        if let imageLocalPath = record.imageLocalPath, !imageLocalPath.isEmpty{
            let directory = try? UserImageStorage.userImagesDirectory()
            localImageUrl = directory?.appending(path: imageLocalPath)
        }
        return .init(
            id: record.id,
            appleId: record.appleId,
            fullName: record.fullName,
            email: record.email,
            dateOfBirth: record.dateOfBirth,
            imageLocalUrl: localImageUrl,
            imageUrl: record.imageUrl,
            serverVersion: metadata?.serverVersion ?? .zero,
            updatedAt: record.updatedAt
        )
    }
}

