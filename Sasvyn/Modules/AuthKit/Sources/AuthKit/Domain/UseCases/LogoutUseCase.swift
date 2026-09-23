//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import Foundation

internal struct LogoutUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.logout()
    }
}
