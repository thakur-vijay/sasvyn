//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum SpokenLanguageRecordMapper {

    nonisolated static func map(
        _ record: SpokenLanguageRecord,
    ) -> SpokenLanguage? {
        guard let proficiency = LanguageProficiency(rawValue: record.proficiency) else { return nil}
        return SpokenLanguage(
            id: record.id,
            languageCode: record.languageCode,
            language: record.language,
            proficiency: proficiency
        )
    }
}

