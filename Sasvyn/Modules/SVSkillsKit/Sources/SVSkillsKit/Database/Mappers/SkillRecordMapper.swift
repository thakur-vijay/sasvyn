//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation
import SVSyncKit

public enum SkillRecordMapper {

    public nonisolated static func map(_ record: SkillRecord, metadata: SyncMetadata?) -> Skill {
        return Skill(
            id: record.id,
            skill: record.skill,
            category: SkillCategory(rawValue: record.category) ?? .languages,
            syncVersion: metadata?.serverVersion ?? 0,
            updatedAt: record.updatedAt
        )
    }

}

