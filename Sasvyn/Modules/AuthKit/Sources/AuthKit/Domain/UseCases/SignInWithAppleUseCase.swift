//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

internal struct SignInWithAppleUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(_ body: LoginRequestDTO) async throws {
       try await repository.appleLogin(body)
    }
}
