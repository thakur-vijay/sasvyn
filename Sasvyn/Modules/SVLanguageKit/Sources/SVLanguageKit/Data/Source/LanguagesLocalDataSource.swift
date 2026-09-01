//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVDatabaseKit

final class LanguagesLocalDataSource: @unchecked Sendable {
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func loadLanguagesJSON() async throws -> [Language] {
        guard let url = Bundle.module.url(
            forResource: "Languages",
            withExtension: "json"
        ) else {
            throw LanguagesLocalDataSourceError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        return try JSONDecoder().decode(
            [Language].self,
            from: data
        )
    }
    
    func fetch() async throws -> [SpokenLanguageRecord]{
        return try await database.read {database in
            try database.fetchAll(SpokenLanguageRecord.self, sorting: [
                .descending(SpokenLanguageRecord.ColumnNames.proficiency)
            ])
        }
    }

    func save(_ language: SpokenLanguage) async throws {
        try await database.write { db in
            if try db.fetchOne(SpokenLanguageRecord.self, filters: [
                .equals(SpokenLanguageRecord.ColumnNames.languageCode, .text(language.languageCode))
            ]) != nil{
                try db.update(
                    table: SpokenLanguageRecord.databaseTableName,
                    values: [
                        SpokenLanguageRecord.ColumnNames.language: .text(language.language),
                        SpokenLanguageRecord.ColumnNames.proficiency: .integer(language.proficiency.rawValue),
                        SpokenLanguageRecord.ColumnNames.updatedAt: .date(.now),
                    ],
                    whereColumn: SpokenLanguageRecord.ColumnNames.languageCode,
                    equals: .text(language.languageCode)
                )
            } else {
                let record = SpokenLanguageRecord(
                    id: language.id,
                    languageCode: language.languageCode,
                    language: language.language,
                    proficiency: language.proficiency.rawValue,
                    createdAt: .now,
                    updatedAt: .now
                )

                try db.insert(record)
            }
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(SpokenLanguageRecord.self, key: id)
        }
    }

}

enum LanguagesLocalDataSourceError: Error {
    case fileNotFound
}
