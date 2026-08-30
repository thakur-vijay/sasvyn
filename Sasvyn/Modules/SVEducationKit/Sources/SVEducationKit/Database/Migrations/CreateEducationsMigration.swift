//
//  CreateChatListsMigration.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import SVDatabaseKit

struct CreateEducationsMigration: DatabaseMigration {

    let identifier = "create_educations"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            EducationRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("degree").notNull()
            table.text("field_of_study").notNull()
            table.text("institution").notNull()
            table.datetime("start_date").notNull()
            table.datetime("end_date").notNull()
            table.boolean("is_pursuing").notNull()
            table.text("grade").notNull()
            table.text("grade_type").notNull()
            table.text("description").notNull()
            table.datetime("created_at").notNull()
            table.datetime("updated_at").notNull()
        }
    }
}
