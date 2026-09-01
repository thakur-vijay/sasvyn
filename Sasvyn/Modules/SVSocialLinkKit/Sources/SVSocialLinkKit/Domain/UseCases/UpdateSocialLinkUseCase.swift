//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public struct UpdateSocialLinkUseCase: Sendable {
    private let repository: SocialLinksRepository
    
    init(repository: SocialLinksRepository) {
        self.repository = repository
    }
    
    func execute(_ link: SocialLink)async throws{
        try await repository.update(link)
    }
}
