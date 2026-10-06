//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public struct UpdateSkillUseCase: Sendable {
    private let repository: SkillsRepository
    
    init(repository: SkillsRepository) {
        self.repository = repository
    }
    
    func execute(_ skill: Skill)async throws {
        try await repository.update(skill: skill)
    }
}
