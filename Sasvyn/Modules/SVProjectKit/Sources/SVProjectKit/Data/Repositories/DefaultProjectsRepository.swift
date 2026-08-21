//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSkillsKit

public final class DefaultProjectsRepository: ProjectsRepository {

    private let dataSource: ProjectsLocalDataSource
    
    init(dataSource: ProjectsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(search: String) async throws -> [Project] {
        let allProjects = try await dataSource.fetch(search: search)
        let directory = try ProjectStorage.projectsDirectory()

        return allProjects.compactMap {
            return ProjectRecordMapper.map(
                $0,
                projectsDirectory: directory
            )
        }
    }
    
    public func add(project: Project) async throws {
        try await dataSource.create(project: project)
    }
    
    public func update(project: Project) async throws {
        try await dataSource.update(project: project)
    }
    
    public func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }

    public func fetch(id: String) async throws -> Project? {
        let (projectRecord, skillsRecord) = try await dataSource.fetch(id: id)
        let directory = try ProjectStorage.projectsDirectory()
        var project = ProjectRecordMapper.map(projectRecord, projectsDirectory: directory)
        let skills = skillsRecord.compactMap { SkillRecordMapper.map($0) }
        project?.techStack = skills
        return project
    }
    
    public func removeSkill(id: String, from projectID: String) async throws {
        try await dataSource.removeSkill(skillID: id, fromProject: projectID)
    }
}
