//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import Foundation
import SVDatabaseKit

struct ProjectScreenshotRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "project_screenshots"
    
    let id: String
    
    let path: String
    
    let projectId: String
    
    let order: Int
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, path, order
        case projectId = "project_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

extension ProjectScreenshotRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let path = SVColumnName("path")
        static let projectId = SVColumnName("project_id")
        static let order = SVColumnName("order")
        static let createdAt = SVColumnName("created_at")
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension ProjectScreenshotRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        static let path = SVColumn("path")
        static let projectId = SVColumn("project_id")
        static let order = SVColumn("order")
        static let createdAt = SVColumn("created_at")
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
