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
        print("ROLE", project.role)
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
    
    struct ProjectSkillRow: FetchableRecord, Decodable {

        let projectID: String
        let projectIconPath: String
        let projectName: String
        let projectCategory: String
        let projectTagline: String
        let projectOverview: String
        let projectRole: String
        let projectCreatedAt: Date
        let projectUpdatedAt: Date

        let skillID: String?
        let skill: String?
        let skillCategory: String?
        let skillCreatedAt: Date?
        let skillUpdatedAt: Date?

        enum CodingKeys: String, CodingKey {
            case projectID = "project_id"
            case projectIconPath = "project_icon_path"
            case projectName = "project_name"
            case projectCategory = "project_category"
            case projectTagline = "project_tagline"
            case projectOverview = "project_overview"
            case projectRole = "project_role"
            case projectCreatedAt = "project_created_at"
            case projectUpdatedAt = "project_updated_at"

            case skillID = "skill_id"
            case skill = "skill"
            case skillCategory = "skill_category"
            case skillCreatedAt = "skill_created_at"
            case skillUpdatedAt = "skill_updated_at"
        }
    }

    func fetch(id: String) async throws -> (ProjectRecord, [SkillRecord]) {
        try await database.read { db in

            let rows = try db.fetch(
                ProjectSkillRow.self,
                sql: """
                SELECT
                    p.id AS project_id,
                    p.icon_path AS project_icon_path,
                    p.name AS project_name,
                    p.category AS project_category,
                    p.tagline AS project_tagline,
                    p.overview AS project_overview,
                    p.role AS project_role,
                    p.created_at AS project_created_at,
                    p.updated_at AS project_updated_at,

                    s.id AS skill_id,
                    s.skill AS skill,
                    s.category AS skill_category,
                    s.created_at AS skill_created_at,
                    s.updated_at AS skill_updated_at

                FROM projects p
                LEFT JOIN project_skills ps
                    ON ps.project_id = p.id
                LEFT JOIN skills s
                    ON s.id = ps.skill_id
                WHERE p.id = ?
                """,
                arguments: [.text(id)]
            )

            guard let first = rows.first else {
                throw DatabaseError.recordNotFound
            }

            let project = ProjectRecord(
                id: first.projectID,
                iconPath: first.projectIconPath,
                name: first.projectName,
                category: first.projectCategory,
                tagline: first.projectTagline,
                overview: first.projectOverview,
                role: first.projectRole,
                createdAt: first.projectCreatedAt,
                updatedAt: first.projectUpdatedAt
            )

            let skills = rows.compactMap { row -> SkillRecord? in
                guard
                    let id = row.skillID,
                    let skill = row.skill,
                    let category = row.skillCategory,
                    let createdAt = row.skillCreatedAt,
                    let updatedAt = row.skillUpdatedAt
                else {
                    return nil
                }

                return SkillRecord(
                    id: id,
                    skill: skill,
                    category: category,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }

            return (project, skills)
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
}
