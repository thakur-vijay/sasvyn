//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum SocialLinkRecordMapper {

    nonisolated static func map(
        _ record: SocialLinkRecord,
    ) -> SocialLink? {
        return SocialLink(
            id: record.id,
            type: LinkType(rawValue: record.type),
            url: URL(string: record.url)
        )
    }
}

