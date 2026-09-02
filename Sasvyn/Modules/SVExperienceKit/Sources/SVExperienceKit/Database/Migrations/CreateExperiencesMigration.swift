import SVDatabaseKit

struct CreateExperiencesMigration: DatabaseMigration {
    let identifier = "create_experiences"

    func migrate(_ db: SVDatabase) throws {
        try db.createTable(
            ExperienceRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("role").notNull()
            table.text("company").notNull()
            table.datetime("start_date").notNull()
            table.datetime("end_date")
            table.boolean("is_currently_working").notNull()
        }

        try db.createTable(
            ExperienceResponsibilityRecord.databaseTableName,
            ifNotExists: true
        ) { table in
            table.text("id").primaryKey()
            table.text("experience_id").notNull()
            table.text("responsibility").notNull()
            table.integer("order").notNull()
            table.foreignKey(
                ["experience_id"],
                references: ExperienceRecord.databaseTableName,
                onDeleteCascade: true
            )
        }
    }
}
