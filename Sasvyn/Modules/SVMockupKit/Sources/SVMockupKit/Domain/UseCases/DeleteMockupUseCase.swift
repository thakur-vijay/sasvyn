//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteMockupUseCase: Sendable {
    private let repository: MockupsRepository
    
    init(repository: MockupsRepository) {
        self.repository = repository
    }
    
    func execute(id: String)async throws {
        try await repository.delete(id: id)
    }
}
