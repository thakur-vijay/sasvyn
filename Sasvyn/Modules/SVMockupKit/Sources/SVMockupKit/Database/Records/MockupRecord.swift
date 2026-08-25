//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct MockupRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "mockups"
    
    let id: String
    
    let path: String
    
    let thumbnailPath: String
    
    let aspectRatio: Double
        
    let fileSize: Int64
    
    let device: String
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, path, device
        
        case fileSize = "file_size"
        
        case aspectRatio = "aspect_ratio"
        
        case thumbnailPath = "thumbnail_path"
        
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension MockupRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let createdAt = SVColumnName("created_at")
    }
}

extension MockupRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
                
        static let path = SVColumn("path")
        
        static let thumbnailPath = SVColumn("thumbnail_path")
                        
        static let fileSize = SVColumn("file_size")
        
        static let device = SVColumn("device")
        
        static let aspectRatio = SVColumn("aspect_ratio")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
