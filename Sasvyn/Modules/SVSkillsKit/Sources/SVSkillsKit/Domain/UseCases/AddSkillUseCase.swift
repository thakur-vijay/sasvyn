//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddSkillUseCase: Sendable {
    private let repository: SkillsRepository
    
    init(repository: SkillsRepository) {
        self.repository = repository
    }
    
    func execute(skills: [Skill])async throws {
        try await repository.add(skills: skills)
    }
}
