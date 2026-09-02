//
//  FetchProjectsUseCase 2.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 01/09/26.
//


import Foundation

public struct FetchProjectsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(search: String)async throws->[Project] {
        try await repository.fetch(search: search)
    }
}