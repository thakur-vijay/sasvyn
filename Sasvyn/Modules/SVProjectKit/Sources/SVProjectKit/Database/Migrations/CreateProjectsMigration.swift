//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateProjectsMigration: DatabaseMigration {

    let identifier = "create_projects"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable("projects", ifNotExists: true) { table in
            table.text("id").primaryKey()
            table.text("icon_path").notNull()
            table.text("name").notNull()
            table.text("category").notNull()
            table.text("tagline").notNull()
            table.text("overview").notNull()
            table.text("role").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
