//
//  AddRoleToProjectsMigration.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import SVDatabaseKit

struct AddRoleToProjectsMigration: DatabaseMigration {

    let identifier = "add_role_to_projects"

    func migrate(_ db: SVDatabase) throws {
        try db.alterTable("projects") { table in
            table.text("role").notNull().defaults(to: "")
        }
    }
}
