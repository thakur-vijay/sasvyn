//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteSkillUseCase: Sendable {
    private let repository: SkillsRepository
    
    init(repository: SkillsRepository) {
        self.repository = repository
    }
    
    func execute(id: String)async throws {
        try await repository.delete(id: id)
    }
}
