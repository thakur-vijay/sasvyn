//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import Foundation

public struct RemoveSkillFromProjectUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(id: String, from projectID: String)async throws{
        try await repository.removeSkill(id: id, from: projectID)
    }
}
