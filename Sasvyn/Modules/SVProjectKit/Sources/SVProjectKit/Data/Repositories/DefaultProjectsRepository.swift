//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultProjectsRepository: ProjectsRepository {

    private let dataSource: ProjectsLocalDataSource
    
    init(dataSource: ProjectsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [Project] {
        let allProjects = try await dataSource.fetch()
        let directory = try ProjectStorage.projectsDirectory()

        return allProjects.compactMap {
            let url = directory.appending(path: $0.iconPath)

            print("ICON URL:", url)
            print(
                "ICON EXISTS:",
                FileManager.default.fileExists(atPath: url.path)
            )

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
}
