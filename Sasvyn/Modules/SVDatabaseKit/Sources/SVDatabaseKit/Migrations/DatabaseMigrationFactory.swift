//
//  DatabaseMigrationFactory.swift
//  Sayvyn
//
//  Created by Vijay Thakur on 03/06/26.
//

import GRDB

public enum DatabaseMigratorFactory {

    public static func makeMigrator(
        migrations: [DatabaseMigration]
    ) -> GRDB.DatabaseMigrator {

        var migrator = GRDB.DatabaseMigrator()

        migrations.forEach { migration in
            migrator.registerMigration(migration.identifier) { db in
                try migration.migrate(SVDatabase(db: db))
            }
        }

        return migrator
    }
}
