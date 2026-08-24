//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchMockupsUseCase: Sendable {
    private let repository: MockupsRepository
    
    init(repository: MockupsRepository) {
        self.repository = repository
    }
    
    func execute()async throws->[MockupImage] {
        let models = try await repository.fetch()
        return models.map { MockupImageMapper.map($0)}
    }
}
