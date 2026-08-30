//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchSpokenLanguagesUseCase: Sendable {
    private let repository: LanguagesRepository
    
    init(repository: LanguagesRepository) {
        self.repository = repository
    }
    
    func execute()async throws->[SpokenLanguage] {
        try await repository.fetch()
    }
}
