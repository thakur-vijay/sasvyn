//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct ProjectRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "projects"
    
    let id: String
    
    let iconPath: String
    
    let name: String
    
    let category: String
    
    let tagline: String
    
    let overview: String
    
    let role: String
        
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, name, category, tagline, overview, role
        case iconPath = "icon_path"
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension ProjectRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let iconPath = SVColumnName("icon_path")
        static let name = SVColumnName("name")
        static let category = SVColumnName("category")
        static let tagline = SVColumnName("tagline")
        static let overview = SVColumnName("overview")
        static let role = SVColumnName("role")
        static let createdAt = SVColumnName("created_at")
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension ProjectRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        
        static let iconPath = SVColumn("icon_path")
        
        static let name = SVColumn("name")
                
        static let category = SVColumn("category")
                
        static let tagline = SVColumn("tagline")
        
        static let overview = SVColumn("overview")
        
        static let role = SVColumn("role")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
