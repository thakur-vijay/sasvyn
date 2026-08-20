//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateSkillsMigration: DatabaseMigration {

    let identifier = "create_skills"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable("skills", ifNotExists: true) { table in
            table.text("id").primaryKey()
            table.text("skill").notNull()
            table.text("category").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
