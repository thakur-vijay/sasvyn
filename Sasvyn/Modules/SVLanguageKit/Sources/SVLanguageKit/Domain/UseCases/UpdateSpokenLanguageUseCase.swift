//
//  File.swift
//  SVEducationKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public struct UpdateSpokenLanguageUseCase: Sendable {
    private let repository: LanguagesRepository
    
    init(repository: LanguagesRepository) {
        self.repository = repository
    }
    
    func execute(_ language: SpokenLanguage)async throws {
        try await repository.update(language)
    }
}
