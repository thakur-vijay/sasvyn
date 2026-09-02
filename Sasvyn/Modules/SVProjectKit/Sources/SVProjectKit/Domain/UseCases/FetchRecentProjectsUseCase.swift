//
//  FetchProjectsUseCase 2.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 01/09/26.
//


import Foundation

public struct FetchRecentProjectsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int)async throws->[Project] {
        try await repository.fetchRecent(limit: limit)
    }
}
