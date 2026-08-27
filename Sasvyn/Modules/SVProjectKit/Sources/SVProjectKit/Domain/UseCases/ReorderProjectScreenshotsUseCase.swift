//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 27/08/26.
//

import Foundation

public struct ReorderProjectScreenshotsUseCase: Sendable {
    private let repository: ProjectsRepository
    
    init(repository: ProjectsRepository) {
        self.repository = repository
    }
    
    func execute(screenshots: [ProjectScreenshot])async throws {
        try await repository.reorderProjectScreenshots(screenshots: screenshots)
    }
}
