//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchProjectsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute()async throws->[Project] {
        try await repository.fetch()
    }
}
