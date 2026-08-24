//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateMockupsMigration: DatabaseMigration {

    let identifier = "create_mockups"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable("mockups", ifNotExists: true) { table in
            table.text("id").primaryKey()
            table.text("path").notNull()
            table.text("thumbnail_path").notNull()
            table.double("aspect_ratio").notNull()
            table.integer("file_size").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
