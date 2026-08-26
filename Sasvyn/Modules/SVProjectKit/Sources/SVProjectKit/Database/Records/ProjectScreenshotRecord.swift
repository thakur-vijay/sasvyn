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
    
    let fileName: String
    
    let projectId: String
    
    let order: Int
    
    let mockupID: String
    
    let device: String
    
    let aspectRatio: Double
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, order, device
        case fileName = "file_name"
        case projectId = "project_id"
        case mockupID = "mockup_id"
        case aspectRatio = "aspect_ratio"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

extension ProjectScreenshotRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let fileName = SVColumnName("file_name")
        static let projectId = SVColumnName("project_id")
        static let mockupID = SVColumnName("mockup_id")
        static let device = SVColumnName("device")
        static let aspectRatio = SVColumnName("aspect_ratio")
        static let order = SVColumnName("order")
        static let createdAt = SVColumnName("created_at")
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension ProjectScreenshotRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        static let fileName = SVColumn("file_name")
        static let projectId = SVColumn("project_id")
        static let mockupID = SVColumn("mockup_id")
        static let device = SVColumn("device")
        static let aspectRatio = SVColumn("aspect_ratio")
        static let order = SVColumn("order")
        static let createdAt = SVColumn("created_at")
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
