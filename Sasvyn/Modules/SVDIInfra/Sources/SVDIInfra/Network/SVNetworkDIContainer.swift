//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit

public final class SVNetworkDIContainer {

    public lazy var client: NetworkClientProtocol = {
        NetworkClient(configuration: configuration)
    }()
    
    public lazy var tokenStore: TokenStore = {
        SVTokenStore()
    }()
    
    public lazy var authManager: AuthManager = {
        AuthManager(
            tokenStore: tokenStore,
            httpClient: HTTPClient(),
            environment: .production,
            resolver: EnvironmentResolver()) { refreshToken in
                RefreshTokenEndpoint(
                    refreshToken: refreshToken
                )
            }
    }()

    private lazy var configuration: NetworkClientConfiguration = {
        NetworkClientConfiguration(
            environment: .production,
            resolver: EnvironmentResolver(),
            authManager: authManager,
            logger: NetworkLogger(),
            decoder: jsonDecoder
        )
    }()

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
