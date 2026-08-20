//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateDocumentsMigration: DatabaseMigration {

    let identifier = "create_documents"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable("documents", ifNotExists: true) { table in
            table.text("id").primaryKey()
            table.text("name").notNull()
            table.text("path").notNull()
            table.text("category").notNull()
            table.integer("file_size").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
