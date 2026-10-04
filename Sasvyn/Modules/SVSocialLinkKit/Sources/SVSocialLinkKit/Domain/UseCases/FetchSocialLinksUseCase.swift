//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchSocialLinksUseCase: Sendable {
    private let repository: SocialLinksRepository
    
    init(repository: SocialLinksRepository) {
        self.repository = repository
    }
    
    func execute()-> AsyncStream<[SocialLink]>{
        repository.fetch()
    }
}
