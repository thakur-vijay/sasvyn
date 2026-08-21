//
//  CreateProjectSkillsMigration.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import SVDatabaseKit

struct CreateProjectSkillsMigration: DatabaseMigration {

    let identifier = "create_project_skills"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable("project_skills", ifNotExists: true) { table in
            table.text("project_id").notNull()
            table.text("skill_id").notNull()
        }
    }
}
