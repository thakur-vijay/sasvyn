//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum UserRecordMapper {

    nonisolated static func map(
        _ record: UserRecord,
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
            serverVersion: record.serverVersion,
            updatedAt: record.updatedAt
        )
    }
}

