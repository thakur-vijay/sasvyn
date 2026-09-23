//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import Foundation

public struct FetchCurrentUserUseCase: Sendable {
    private let repository: UsersRepository
    
    init(repository: UsersRepository) {
        self.repository = repository
    }
    
    func execute()async throws-> User {
        try await repository.fetchCurrentUser()
    }
}
