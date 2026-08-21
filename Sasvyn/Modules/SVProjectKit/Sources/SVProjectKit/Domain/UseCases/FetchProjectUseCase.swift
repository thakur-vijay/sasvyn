//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import Foundation

public struct FetchProjectUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(id: String)async throws-> Project? {
        try await repository.fetch(id: id)
    }
}
