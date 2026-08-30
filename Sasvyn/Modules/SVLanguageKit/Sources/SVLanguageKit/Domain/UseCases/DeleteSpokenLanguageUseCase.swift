//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteSpokenLanguageUseCase: Sendable {
    private let repository: LanguagesRepository
    
    init(repository: LanguagesRepository) {
        self.repository = repository
    }
    
    func execute(_ id: String)async throws {
        try await repository.delete(id)
    }
}
