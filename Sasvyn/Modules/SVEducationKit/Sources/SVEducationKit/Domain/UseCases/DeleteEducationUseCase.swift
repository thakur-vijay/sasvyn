//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteEducationUseCase: Sendable {
    private let repository: EducationsRepository
    
    init(repository: EducationsRepository) {
        self.repository = repository
    }
    
    func execute(_ id: String)async throws {
        try await repository.delete(id)
    }
}
