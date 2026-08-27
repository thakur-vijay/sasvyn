//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 26/08/26.
//

import Foundation

public struct DeleteProjectScreenshotsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(screenshots: [ProjectScreenshot])async throws {
        try await repository.deleteProjectScreenshots(screenshots: screenshots)
    }
}
