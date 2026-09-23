//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit
import SVNetwork

struct CreateUsersMigration: DatabaseMigration {

    let identifier = "create_users"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            UserRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("apple_id").notNull()
            table.text("full_name").notNull()
            table.text("email").notNull()
            table.date("date_of_birth")
            table.text("image_local_path")
            table.text("image_url")
            table.text("sync_status").notNull().defaults(to: SyncStatus.synced.rawValue)
            table.text("profile_sync_status").notNull().defaults(to: SyncStatus.synced.rawValue)
            table.text("image_sync_status").notNull().defaults(to: SyncStatus.synced.rawValue)
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
