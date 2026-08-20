//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class DocumentsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch(category: DocumentCategory?) async throws -> [DocumentRecord]{
        var filters: [SVDatabaseFilter] = []
        if let category {
            filters.append(.equals(DocumentRecord.ColumnNames.category, .text(category.rawValue)))
        }
        return try await database.read {[filters] database in
            try database.fetchAll(DocumentRecord.self, filters: filters, sorting: [
                .ascending(DocumentRecord.ColumnNames.createdAt)
            ])
        }
    }

    func create(document: Document) async throws {
        try await database.write { db in

            let record = DocumentRecord(
                id: document.id,
                name: document.name,
                path: try DocumentStorage.relativePath(
                    for: document.url
                ),
                category: document.category.rawValue,
                fileSize: document.fileSize,
                createdAt: document.createdAt,
                updatedAt: document.createdAt
            )

            try db.insert(record)
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(DocumentRecord.self, key: id)
        }
    }
}
