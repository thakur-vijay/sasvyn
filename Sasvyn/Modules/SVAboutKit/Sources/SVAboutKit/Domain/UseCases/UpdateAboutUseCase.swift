//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct UpdateAboutUseCase: Sendable {
    private let repository: AboutRepository
    
    init(repository: AboutRepository) {
        self.repository = repository
    }
    
    func execute(_ about: About)async throws {
        try await repository.save(about)
    }
}
