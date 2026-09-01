//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVDatabaseKit

final class SocialLinksLocalDataSource: @unchecked Sendable {
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [SocialLinkRecord]{
        return try await database.read {database in
            try database.fetchAll(SocialLinkRecord.self, sorting: [
                .descending(SocialLinkRecord.ColumnNames.updatedAt)
            ])
        }
    }

    func create(_ link: SocialLink) async throws {
        try await database.write { db in
            let record = SocialLinkRecord(
                id: link.id,
                type: link.type?.rawValue ?? "",
                url: link.url?.absoluteString ?? "",
                createdAt: .now,
                updatedAt: .now
            )
            try db.insert(record)
        }
    }
    
    func update(_ link: SocialLink) async throws {
        try await database.write { db in
            try db.update(
                table: SocialLinkRecord.databaseTableName,
                values: [
                    SocialLinkRecord.ColumnNames.type: .text(link.type?.rawValue ?? ""),
                    SocialLinkRecord.ColumnNames.url: .text(link.url?.absoluteString ?? ""),
                    SocialLinkRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: SocialLinkRecord.ColumnNames.id,
                equals: .text(link.id)
            )
        }
    }

    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(SocialLinkRecord.self, key: id)
        }
    }

}
