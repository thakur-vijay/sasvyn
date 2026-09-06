//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class AboutLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch(_ userId: String) async throws -> AboutRecord?{
        return try await database.read { database in
            try database.fetchOne(
                AboutRecord.self,
                filters: [.equals(
                    AboutRecord.ColumnNames.userId,
                    .text(
                        userId
                    )
                )]
            )
        }
    }

    func save(about: About) async throws {
        try await database.write { db in
            let record = try db.fetchOne(AboutRecord.self, filters: [.equals(AboutRecord.ColumnNames.userId, .text(about.userId))])
            if record == nil {
                //create
                try db.insert(
                    AboutRecord(
                        userId: about.userId,
                        content: about.content,
                        createdAt: .now,
                        updatedAt: .now
                    )
                )
            }else {
                try db.update(
                    table: AboutRecord.databaseTableName,
                    values: [
                        AboutRecord.ColumnNames.content: .text(about.content),
                        AboutRecord.ColumnNames.updatedAt: .date(.now),
                    ],
                    whereColumn: AboutRecord.ColumnNames.userId,
                    equals: .text(about.userId)
                )
            }
        }
    }
}
