import SVDatabaseKit

public enum ExperiencesDatabaseModule: DatabaseModule {
    public static func register(on migrator: DatabaseMigrator) {
        migrator.add(CreateExperiencesMigration())
    }
}
