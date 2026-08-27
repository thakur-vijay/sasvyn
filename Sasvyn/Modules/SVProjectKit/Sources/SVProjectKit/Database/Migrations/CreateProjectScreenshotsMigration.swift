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
            table.text("id").primaryKey().notNull()
            table.text("file_name").notNull()
            table.text("project_id").notNull()
            table.text("mockup_id").notNull()
            table.text("device").notNull()
            table.double("aspect_ratio").notNull()
            table.integer("sort_order").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
