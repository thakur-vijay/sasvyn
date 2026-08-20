//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct SkillRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "skills"

    let id: String

    let skill: String
    
    let category: String
        
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {

           case id, skill, category

           case createdAt = "created_at"

           case updatedAt = "updated_at"

       }

}

extension SkillRecord {
    
    nonisolated  enum Columns {

        static let id = SVColumn("id")

        static let skill = SVColumn("skill")

        static let category = SVColumn("category")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")

    }

}
