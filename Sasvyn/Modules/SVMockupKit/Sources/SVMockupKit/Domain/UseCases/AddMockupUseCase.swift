//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddMockupUseCase: Sendable {
    private let repository: MockupsRepository
    
    init(repository: MockupsRepository) {
        self.repository = repository
    }
    
    func execute(mockup: MockupModel)async throws {
        try await repository.add(mockup: mockup)
    }
}
