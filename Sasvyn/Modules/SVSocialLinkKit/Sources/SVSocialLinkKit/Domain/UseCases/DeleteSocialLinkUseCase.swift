//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteSocialLinkUseCase: Sendable {
    private let repository: SocialLinksRepository
    
    init(repository: SocialLinksRepository) {
        self.repository = repository
    }
    
    func execute(_ id: String)async throws {
        try await repository.delete(id)
    }
}
