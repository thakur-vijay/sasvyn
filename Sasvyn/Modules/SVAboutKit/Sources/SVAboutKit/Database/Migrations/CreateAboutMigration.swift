//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateAboutMigration: DatabaseMigration {

    let identifier = "create_about"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(AboutRecord.databaseTableName, ifNotExists: true) { table in
            table.text("user_id").primaryKey()
            table.text("content").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
