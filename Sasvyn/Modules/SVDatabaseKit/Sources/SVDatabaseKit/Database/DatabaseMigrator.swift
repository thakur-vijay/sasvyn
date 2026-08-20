//
//  DatabaseMigrator.swift
//  SayvynDatabaseKit
//
//  Created by Vijay Thakur on 03/07/26.
//

import Foundation

public final class DatabaseMigrator {

    private var migrations: [DatabaseMigration] = []

    public init() {}

    public func add(_ migration: DatabaseMigration) {
        migrations.append(migration)
    }

    func build() -> GRDB.DatabaseMigrator {
        DatabaseMigratorFactory.makeMigrator(migrations: migrations)
    }
}

public extension DatabaseMigrator {

    func register<M: DatabaseModule>(
        _ module: M.Type
    ) {
        M.register(on: self)
    }
}
