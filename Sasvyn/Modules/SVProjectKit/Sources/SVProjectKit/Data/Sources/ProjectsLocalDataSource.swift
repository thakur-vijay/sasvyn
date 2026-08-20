//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class ProjectsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [ProjectRecord]{
        return try await database.read {database in
            try database.fetchAll(ProjectRecord.self, sorting: [
                .descending(ProjectRecord.ColumnNames.updatedAt)
            ])
        }
    }

    func create(project: Project) async throws {
        try await database.write { db in
            var iconPath: String = ""
            if let appIconURL = project.icon {
                iconPath = try ProjectStorage.relativePath(for: appIconURL)
            }
            let record = ProjectRecord(
                id: project.id,
                iconPath: iconPath,
                name: project.name,
                category: project.category?.rawValue ?? "",
                tagline: project.tagline,
                overview: project.overview,
                createdAt: .now,
                updatedAt: .now
            )

            try db.insert(record)
        }
    }
    
    func update(project: Project) async throws {
        try await database.write { db in
            let existing = try db.fetchOne(
                ProjectRecord.self,
                filters: [
                    .equals(
                        ProjectRecord.ColumnNames.id,
                        .text(project.id)
                    )
                ]
            )
            var iconPath: String = ""
            if let appIconURL = project.icon {
                iconPath = try ProjectStorage.relativePath(for: appIconURL)
            }else {
                iconPath = existing?.iconPath ?? ""
            }

            try db.update(
                table: ProjectRecord.databaseTableName,
                values: [
                    ProjectRecord.ColumnNames.iconPath: .text(iconPath),
                    ProjectRecord.ColumnNames.name: .text(project.name),
                    ProjectRecord.ColumnNames.category: .text(
                        project.category?.rawValue ??
                        existing?.category ?? ""
                    ),
                    ProjectRecord.ColumnNames.tagline: .text(project.tagline),
                    ProjectRecord.ColumnNames.overview: .text(project.overview),
                    ProjectRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: ProjectRecord.ColumnNames.id,
                equals: .text(project.id)
            )
        }
    }
    
    func delete(id: String) async throws {
        let directory = try ProjectStorage.projectDirectoryURL(
            id: id
        )
        if FileManager.default.fileExists(
            atPath: directory.path
        ) {
            try FileManager.default.removeItem(
                at: directory
            )
        }

        try await database.write { db in
            try db.delete(
                ProjectRecord.self,
                key: id
            )
        }
    }
}
