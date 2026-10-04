//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation
import SVSyncKit

enum SocialLinkRecordMapper {

    nonisolated static func map(
        _ record: SocialLinkRecord,
        metadata: SyncMetadata?
    ) -> SocialLink {
        return SocialLink(
            id: record.id,
            type: LinkType(rawValue: record.type),
            url: URL(string: record.url),
            syncVersion: metadata?.serverVersion ?? 0,
            updatedAt: record.updatedAt
        )
    }
}

