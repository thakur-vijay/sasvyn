//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteProjectUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(id: String)async throws {
        try await repository.delete(id: id)
    }
}
