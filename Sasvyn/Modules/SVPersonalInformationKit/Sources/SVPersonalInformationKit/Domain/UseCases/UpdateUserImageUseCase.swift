//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct UpdateUserImageUseCase: Sendable {
    private let repository: UsersRepository
    
    init(repository: UsersRepository) {
        self.repository = repository
    }
    
    func execute(_ user: User)async throws {
        try await repository.updateImage(user)
    }
}
