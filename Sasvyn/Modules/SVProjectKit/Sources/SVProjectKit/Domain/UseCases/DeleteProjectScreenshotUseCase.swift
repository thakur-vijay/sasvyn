//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 26/08/26.
//

import Foundation

public struct DeleteProjectScreenshotUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(id: String, projectID: String)async throws {
        try await repository.deleteProjectScreenshot(id: id, from: projectID)
    }
}
