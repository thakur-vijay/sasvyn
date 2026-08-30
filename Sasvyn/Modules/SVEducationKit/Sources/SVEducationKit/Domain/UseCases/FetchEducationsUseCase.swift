//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchEducationsUseCase: Sendable {
    private let repository: EducationsRepository
    
    init(repository: EducationsRepository) {
        self.repository = repository
    }
    
    func execute()async throws->[Education] {
        try await repository.fetch()
    }
}
