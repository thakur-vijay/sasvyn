//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateSpokenLanguagesMigration: DatabaseMigration {

    let identifier = "create_spoken_languages"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            SpokenLanguageRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("language_code").unique().notNull()
            table.text("language").notNull()
            table.integer("proficiency").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
