//
//  File.swift
//  SVEducationKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public struct UpdateEducationUseCase: Sendable {
    private let repository: EducationsRepository
    
    init(repository: EducationsRepository) {
        self.repository = repository
    }
    
    func execute(_ education: Education)async throws {
        try await repository.update(education)
    }
}
