//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchSkillsUseCase: Sendable {
    private let repository: SkillsRepository
    
    init(repository: SkillsRepository) {
        self.repository = repository
    }
    
    func execute()async throws->[SkillMainModel] {
        try await repository.fetch()
    }
}
