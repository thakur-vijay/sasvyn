//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 27/08/26.
//

import Foundation

public struct AddProjectScreenshotsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(screenshots: [ProjectScreenshot], projectID: String)async throws {
        try await repository.addProjectScreenshots(screenshots: screenshots, projectID: projectID)
    }
}
