//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateSocialLinksMigration: DatabaseMigration {

    let identifier = "create_social_links"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            SocialLinkRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("type").notNull()
            table.text("url").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
