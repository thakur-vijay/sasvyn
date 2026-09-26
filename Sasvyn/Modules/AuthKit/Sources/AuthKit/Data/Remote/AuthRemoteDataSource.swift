//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import NetworkKit

internal final class AuthRemoteDataSource: Sendable{
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func appleLogin(_ body: SocialLoginRequest) async throws-> LoginResponseDTO{
        let endpoint = AppleLoginEndpoint(body)
        return try await client.request(endpoint)
    }
    
    func logout() async throws {
        try await client.request(LogoutEndpoint())
    }
}
