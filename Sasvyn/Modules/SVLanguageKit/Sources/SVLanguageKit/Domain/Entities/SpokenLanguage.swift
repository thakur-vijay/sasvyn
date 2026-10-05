//
//  SpokenLanguage.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVSyncKit

public struct SpokenLanguage: Identifiable, Hashable, Sendable, SyncableEntity{
    public static let entityType: SVSyncKit.SyncEntityType = .language
    
    public let id: String
    public var languageCode: String
    public var language: String
    public var proficiency: LanguageProficiency
    
    public let syncVersion: Int64
    
    public let updatedAt: Date
    
    public init(
        id: String,
        languageCode: String = "",
        language: String = "",
        proficiency: LanguageProficiency = .elementary,
        syncVersion: Int64 = 1,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.languageCode = languageCode
        self.language = language
        self.proficiency = proficiency
        self.syncVersion = syncVersion
        self.updatedAt = updatedAt
    }
}
