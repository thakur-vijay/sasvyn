//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class SkillsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [SkillRecord]{
        return try await database.read { database in
           try database.fetchAll(SkillRecord.self)
        }
    }

    func create(skills: [Skill]) async throws {
        try await database.write { db in
            for skill in skills {
                let record = SkillRecord(
                    id: skill.id,
                    skill: skill.skill,
                    category: skill.category.rawValue,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                try db.insert(record)
            }
        }
    }
    
    func delete(id: String) async throws {
    
        try await database.write { db in
            try db.delete(SkillRecord.self, key: id)
        }
    }
}
