//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct DocumentRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "documents"
    
    let id: String
    
    let name: String
    
    let path: String
    
    let category: String
    
    let fileSize: Int64
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, name, path, category
        
        case fileSize = "file_size"
        
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension DocumentRecord {
    nonisolated enum ColumnNames {
        static let category = SVColumnName("category")
        static let id = SVColumnName("id")
        static let createdAt = SVColumnName("created_at")
    }
}

extension DocumentRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        
        static let name = SVColumn("name")
        
        static let path = SVColumn("path")
        
        static let category = SVColumn("category")
                
        static let fileSize = SVColumn("file_size")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
