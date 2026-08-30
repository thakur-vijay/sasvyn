//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct SpokenLanguageRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "spoken_languages"
    
    let id: String
    
    let languageCode: String
    
    let language: String
    
    let proficiency: Int
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, language, proficiency
        
        case languageCode = "language_code"
        
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension SpokenLanguageRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        
        static let languageCode = SVColumnName("language_code")
        
        static let language = SVColumnName("language")
        
        static let proficiency = SVColumnName("proficiency")
        
        static let createdAt = SVColumnName("created_at")
        
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension SpokenLanguageRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        
        static let languageCode = SVColumn("language_code")
        
        static let language = SVColumn("language")
        
        static let proficiency = SVColumn("proficiency")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
