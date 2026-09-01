//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddSocialLinkUseCase: Sendable {
    private let repository: SocialLinksRepository
    
    init(repository: SocialLinksRepository) {
        self.repository = repository
    }
    
    func execute(_ link: SocialLink)async throws {
        try await repository.add(link)
    }
}
