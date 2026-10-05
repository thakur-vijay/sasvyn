//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
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
