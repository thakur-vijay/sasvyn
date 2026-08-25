//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class MockupsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [MockupRecord]{
        return try await database.read { database in
            try database.fetchAll(MockupRecord.self, sorting: [
                .ascending(MockupRecord.ColumnNames.createdAt)
            ])
        }
    }

    func create(mockup: MockupModel) async throws {
        try await database.write { db in
            guard let url = mockup.url, let thumbnailURL = mockup.thumbnail else {
                throw URLError(.badURL)
            }
            let record = MockupRecord(
                id: mockup.id,
                path: try MockupStorage.relativePath(for: url),
                thumbnailPath: try MockupStorage.relativePath(for: thumbnailURL),
                aspectRatio: mockup.aspectRatio,
                fileSize: mockup.size,
                device: mockup.device,
                createdAt: mockup.createdAt,
                updatedAt: mockup.createdAt
            )

            try db.insert(record)
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            guard let mockup = try db.fetchOne(
                MockupRecord.self,
                filters: [.equals(
                    MockupRecord.ColumnNames.id,
                    .text(id)
                )]
            ) else {
                throw URLError(.resourceUnavailable)
            }
            try MockupStorage.removeItem(path: mockup.path)
            try db.delete(MockupRecord.self, key: id)
        }
    }
}
