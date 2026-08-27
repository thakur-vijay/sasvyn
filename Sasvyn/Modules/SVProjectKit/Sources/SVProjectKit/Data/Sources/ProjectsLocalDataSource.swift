//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVSkillsKit

final class ProjectsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch(search: String) async throws -> [ProjectRecord] {
        var filters: [SVDatabaseFilter] = []

        if search.isNotEmpty {
            filters = [
                .or([
                    .like(ProjectRecord.ColumnNames.name, search),
                    .like(ProjectRecord.ColumnNames.category, search),
                    .like(ProjectRecord.ColumnNames.tagline, search),
                    .like(ProjectRecord.ColumnNames.overview, search),
                    .like(ProjectRecord.ColumnNames.role, search)
                ])
            ]
        }

        return try await database.read {[filters] database in
            try database.fetchAll(
                ProjectRecord.self,
                filters: filters,
                sorting: [
                    .descending(ProjectRecord.ColumnNames.updatedAt)
                ]
            )
        }
    }

    func create(project: Project) async throws {
        try await database.write {[weak self] db in
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
                role: project.role,
                appDescription: project.description,
                createdAt: .now,
                updatedAt: .now
            )

            try db.insert(record)
            
            try self?.setTechStack(
                projectID: project.id,
                skillIDs: project.techStack.map { $0.id },
                db: db
            )
        }
    }
    
    func update(project: Project) async throws {
        try await database.write {[weak self] db in
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
                print("SAVING APPICON URL IN DB", appIconURL)
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
                    ProjectRecord.ColumnNames.role: .text(project.role),
                    ProjectRecord.ColumnNames.appDescription: .text(project.description),
                    ProjectRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: ProjectRecord.ColumnNames.id,
                equals: .text(project.id)
            )
            
            try self?.setTechStack(
                projectID: project.id,
                skillIDs: project.techStack.map { $0.id },
                db: db
            )
        }
    }
    
    struct ProjectDetailRow: FetchableRecord, Decodable {

        let projectID: String
        let projectIconPath: String
        let projectName: String
        let projectCategory: String
        let projectTagline: String
        let projectOverview: String
        let projectRole: String
        let projectDescription: String
        let projectCreatedAt: Date
        let projectUpdatedAt: Date

        let skillsJSON: String
        let screenshotsJSON: String

        enum CodingKeys: String, CodingKey {
            case projectID = "project_id"
            case projectIconPath = "project_icon_path"
            case projectName = "project_name"
            case projectCategory = "project_category"
            case projectTagline = "project_tagline"
            case projectOverview = "project_overview"
            case projectRole = "project_role"
            case projectDescription = "project_description"
            case projectCreatedAt = "project_created_at"
            case projectUpdatedAt = "project_updated_at"

            case skillsJSON = "skills_json"
            case screenshotsJSON = "screenshots_json"
        }
    }
    

    func fetch(
        id: String
    ) async throws -> (
        ProjectRecord,
        [SkillRecord],
        [ProjectScreenshotRecord]
    ) {
        try await database.read { db in

            let row = try db.fetchOne(
                ProjectDetailRow.self,
                sql: """
                SELECT
                    p.id AS project_id,
                    p.icon_path AS project_icon_path,
                    p.name AS project_name,
                    p.category AS project_category,
                    p.tagline AS project_tagline,
                    p.overview AS project_overview,
                    p.role AS project_role,
                    p.app_description AS project_description,
                    p.created_at AS project_created_at,
                    p.updated_at AS project_updated_at,

                    COALESCE(
                        (
                            SELECT json_group_array(
                                json_object(
                                    'id', s.id,
                                    'skill', s.skill,
                                    'category', s.category,
                                    'created_at', s.created_at,
                                    'updated_at', s.updated_at
                                )
                            )
                            FROM project_skills ps
                            INNER JOIN skills s
                                ON s.id = ps.skill_id
                            WHERE ps.project_id = p.id
                        ),
                        '[]'
                    ) AS skills_json,

                    COALESCE(
                        (
                            SELECT json_group_array(
                                json_object(
                                    'id', ps.id,
                                    'file_name', ps.file_name,
                                    'project_id', ps.project_id,
                                    'sort_order', ps."sort_order",
                                    'mockup_id', ps.mockup_id,
                                    'device', ps.device,
                                    'aspect_ratio', ps.aspect_ratio,
                                    'created_at', ps.created_at,
                                    'updated_at', ps.updated_at
                                )
                            )
                            FROM (
                                SELECT *
                                FROM project_screenshots
                                WHERE project_id = p.id
                                ORDER BY "sort_order" ASC
                            ) ps
                        ),
                        '[]'
                    ) AS screenshots_json

                FROM projects p
                WHERE p.id = ?
                """,
                arguments: [.text(id)]
            )

            guard let row else {
                throw DatabaseError.recordNotFound
            }

            let project = ProjectRecord(
                id: row.projectID,
                iconPath: row.projectIconPath,
                name: row.projectName,
                category: row.projectCategory,
                tagline: row.projectTagline,
                overview: row.projectOverview,
                role: row.projectRole,
                appDescription: row.projectDescription,
                createdAt: row.projectCreatedAt,
                updatedAt: row.projectUpdatedAt
            )

            let decoder = SVJSONDecoder.make()

            let skills = try decoder.decode(
                [SkillRecord].self,
                from: Data(row.skillsJSON.utf8)
            )

            let screenshots = try decoder.decode(
                [ProjectScreenshotRecord].self,
                from: Data(row.screenshotsJSON.utf8)
            )

            return (
                project,
                skills,
                screenshots
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
    
    func addScreenshots(
        projectID: String,
        screenshots: [ProjectScreenshot],
    ) async throws {
        try await database.write { db in
            for screenshot in screenshots {
                guard let sourceURL = screenshot.imageURL else {
                    continue
                }

                let destinationURL = try ProjectStorage.copyScreenshot(
                    from: sourceURL,
                    projectID: projectID
                )

                try db.insert(
                    ProjectScreenshotRecord(
                        id: screenshot.id,
                        fileName: destinationURL.lastPathComponent,
                        projectId: projectID,
                        sortOrder: screenshot.order,
                        mockupID: screenshot.mockupID,
                        device: screenshot.device,
                        aspectRatio: screenshot.aspectRatio,
                        createdAt: .now,
                        updatedAt: .now
                    )
                )
            }
        }
    }
    
    private func setTechStack(
        projectID: String,
        skillIDs: [String],
        db: SVDatabase
    ) throws {
        try db.execute(
            sql: "DELETE FROM project_skills WHERE project_id = ?",
            arguments: [.text(projectID)]
        )

        for skillID in skillIDs {
            try db.insert(
                ProjectSkillRecord(
                    projectID: projectID,
                    skillID: skillID
                )
            )
        }
    }
    
    func removeSkill(
        skillID: String,
        fromProject projectID: String
    ) async throws {
        try await database.write { db in
            try db.delete(
                ProjectSkillRecord.self,
                where: .and(
                    .equals(ProjectSkillRecord.ColumnNames.projectID, .text(projectID)),
                    .equals(
                        ProjectSkillRecord.ColumnNames.skillID,
                        .text(
                            skillID
                        )
                    )
                )
            )
        }
    }
    
    func deleteScreenshot(id: String, projectID: String) async throws {
        try await database.write { db in
            guard let screenshotRecord = try db.fetchOne(
                ProjectScreenshotRecord.self,
                filters: [.equals(ProjectScreenshotRecord.ColumnNames.id, .text(id))]
            ) else {
                throw DatabaseError.recordNotFound
            }
            
            let screenshotURL = try ProjectStorage.screenshotURL(
                projectID: projectID,
                fileName: screenshotRecord.fileName
            )
            try FileManager.default.removeItem(at: screenshotURL)
            try db.delete(
                ProjectScreenshotRecord.self,
                key: id
            )
        }
    }
    
    func deleteScreenshots(screenshots: [ProjectScreenshot]) async throws {
        try await database.write { db in
            try screenshots.forEach { screenshot in
                guard let screenshotURL = screenshot.imageURL else { throw DatabaseError.recordNotFound }
                try FileManager.default.removeItem(at: screenshotURL)
                try db.delete(
                    ProjectScreenshotRecord.self,
                    key: screenshot.id
                )
            }
        }
    }
    
    func updateScreenshotsOrder(screenshots: [ProjectScreenshot]) async throws {
        try await database.write { db in
            try screenshots.forEach { screenshot in
                try db.update(
                    table: ProjectScreenshotRecord.databaseTableName,
                    values: [
                        ProjectScreenshotRecord.ColumnNames.sortOrder: .integer(screenshot.order),
                        ProjectScreenshotRecord.ColumnNames.updatedAt: .date(.now),
                    ],
                    whereColumn: ProjectScreenshotRecord.ColumnNames.id,
                    equals: .text(screenshot.id)
                )
            }
        }
    }
}

public enum SVJSONDecoder {
    
    public static func make() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
}
