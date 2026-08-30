//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import SVSkillsKit
import SVDocumentKit
import SVProjectKit
import SVMockupKit
import SVEducationKit
import SVLanguageKit

public final class SVDatabaseContainer {
    
    public lazy var appDatabase: AppDatabase = {
        do {
            let migrator = DatabaseMigrator()
            migrator.register(SkillsDatabaseModule.self)
            migrator.register(DocumentsDatabaseModule.self)
            migrator.register(ProjectsDatabaseModule.self)
            migrator.register(MockupsDatabaseModule.self)
            migrator.register(EducationsDatabaseModule.self)
            migrator.register(SpokenLanguagesDatabaseModule.self)

            let database = try AppDatabase(
                migrator: migrator
            )
            print("DB URL", database.dbQueue.path)
            return database
        } catch {
            fatalError("Failed to initialize database: \(error)")
        }
    }()
}
