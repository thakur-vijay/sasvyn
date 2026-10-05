//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation
import SVSyncKit

enum SpokenLanguageRecordMapper {

    nonisolated static func map(
        _ record: SpokenLanguageRecord,
        metadata: SyncMetadata?
    ) -> SpokenLanguage {
        return SpokenLanguage(
            id: record.id,
            languageCode: record.languageCode,
            language: record.language,
            proficiency: LanguageProficiency(rawValue: record.proficiency) ?? .elementary,
            syncVersion: metadata?.serverVersion ?? 0,
            updatedAt: record.updatedAt
        )
    }
}

