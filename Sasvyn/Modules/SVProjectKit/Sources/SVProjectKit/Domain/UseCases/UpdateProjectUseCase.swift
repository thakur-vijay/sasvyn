//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct UpdateProjectUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(project: Project)async throws {
        try await repository.update(project: project)
    }
}
