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
        let directory = try? UserImageStorage.userImagesDirectory()
        let localImageUrl = directory?.appending(path: record.imageLocalPath ?? "")
        print(localImageUrl, record.imageLocalPath)
        return .init(
            id: record.id,
            appleId: record.appleId,
            fullName: record.fullName,
            email: record.email,
            dateOfBirth: record.dateOfBirth,
            imageLocalUrl: localImageUrl,
            imageUrl: record.imageUrl
        )
    }
}

