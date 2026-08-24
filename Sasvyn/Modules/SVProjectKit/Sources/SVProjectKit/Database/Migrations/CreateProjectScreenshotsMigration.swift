//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import SVDatabaseKit

struct CreateProjectScreenshotsMigration: DatabaseMigration {

    let identifier = "create_project_screenshots"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            ProjectScreenshotRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").notNull()
            table.text("path").notNull()
            table.text("project_id").notNull()
            table.integer("order").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
