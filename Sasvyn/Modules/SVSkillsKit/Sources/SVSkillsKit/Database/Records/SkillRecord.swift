//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

public struct SkillRecord: Codable, Sendable, SVFetchableRecord, SVPersistableRecord{
    
    public static let databaseTableName: String = "skills"

    public let id: String

    public let skill: String
    
    public let category: String
        
    public let createdAt: Date
    
    public let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {

           case id, skill, category

           case createdAt = "created_at"

           case updatedAt = "updated_at"

       }
    
    public init(id: String, skill: String, category: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.skill = skill
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

public extension SkillRecord {
    nonisolated enum ColumnNames {
        static public let id = SVColumnName("id")
    }
}

extension SkillRecord {
    
    nonisolated  public enum Columns {

        static let id = SVColumn("id")

        static let skill = SVColumn("skill")

        static let category = SVColumn("category")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")

    }

}
