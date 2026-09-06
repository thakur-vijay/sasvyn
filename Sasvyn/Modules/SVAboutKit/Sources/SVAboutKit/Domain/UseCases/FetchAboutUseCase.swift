//
//  File.swift
//  SVAboutKit
//
//  Created by Vijay Thakur on 06/09/26.
//

import Foundation

public struct FetchAboutUseCase: Sendable {
    private let repository: AboutRepository
    
    init(repository: AboutRepository) {
        self.repository = repository
    }
    
    func execute(_ userId: String)async throws-> About{
        try await repository.fetch(userId)
    }
}
