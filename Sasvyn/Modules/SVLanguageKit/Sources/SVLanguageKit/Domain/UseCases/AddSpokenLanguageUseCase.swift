//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddSpokenLanguageUseCase: Sendable {
    private let repository: LanguagesRepository
    
    init(repository: LanguagesRepository) {
        self.repository = repository
    }
    
    func execute(_ language: SpokenLanguage)async throws {
        try await repository.add(language)
    }
}
