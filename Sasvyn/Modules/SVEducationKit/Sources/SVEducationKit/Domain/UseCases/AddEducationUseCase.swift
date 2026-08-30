//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddEducationUseCase: Sendable {
    private let repository: EducationsRepository
    
    init(repository: EducationsRepository) {
        self.repository = repository
    }
    
    func execute(_ education: Education)async throws {
        try await repository.add(education)
    }
}
