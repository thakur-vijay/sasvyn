//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct AboutRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "abouts"

    let userId: String

    let content: String

    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {

           case content

           case userId = "user_id"
        
           case createdAt = "created_at"

           case updatedAt = "updated_at"

       }

}

extension AboutRecord {
    
    nonisolated  enum ColumnNames {

        static let userId = SVColumnName("user_id")

        static let content = SVColumnName("content")
        
        static let createdAt = SVColumnName("created_at")
        
        static let updatedAt = SVColumnName("updated_at")

    }

}

extension AboutRecord {
    
    nonisolated  enum Columns {

        static let userId = SVColumn("user_id")

        static let content = SVColumn("content")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")

    }

}
