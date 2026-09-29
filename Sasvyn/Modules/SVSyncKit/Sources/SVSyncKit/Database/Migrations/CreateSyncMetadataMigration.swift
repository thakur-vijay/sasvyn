//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit
import SVNetwork

struct CreateSyncMetadataMigration: DatabaseMigration {

    let identifier = "create_sync_metadata"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            SyncMetadataRecord.databaseTableName,
            ifNotExists: true
        ) { table in

            table.text("id").primaryKey()
            table.text("entity_type").notNull()
            table.text("entity_id").notNull()

            table.text("sync_status")
                .notNull()
                .defaults(to: SyncStatus.synced.rawValue)

            table.integer("server_version")
                .notNull()
                .defaults(to: 0)

            table.datetime("synced_at")

            table.text("sync_operation_id")
            table.text("sync_operation")

            table.integer("sync_retry_count")
                .notNull()
                .defaults(to: 0)

            table.text("sync_error")
        }
    }
}
