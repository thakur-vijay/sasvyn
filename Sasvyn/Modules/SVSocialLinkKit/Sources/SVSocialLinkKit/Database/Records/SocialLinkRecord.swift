//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct SocialLinkRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "social_links"
    
    let id: String
    
    let type: String
    
    let url: String
        
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, type, url
                
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension SocialLinkRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        
        static let type = SVColumnName("type")
        
        static let url = SVColumnName("url")
                
        static let createdAt = SVColumnName("created_at")
        
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension SocialLinkRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        
        static let type = SVColumn("type")
        
        static let url = SVColumn("url")
                
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
