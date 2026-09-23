//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit

public final class SVNetworkDIContainer {
    
    public init(){
        
    }

    public lazy var client: NetworkClientProtocol = {
        NetworkClient(configuration: configuration)
    }()
    
    public lazy var tokenStore: TokenStore = {
        SVTokenStore()
    }()
    
    private let environment: AppEnvironment = .development
    private let environmentResolver = EnvironmentResolver()

    private lazy var httpClient: HTTPClient = {
        HTTPClient()
    }()
    
    public lazy var imageUploader: ImageUploader = {
        DefaultImageUploader(
            client: client,
            httpClient: httpClient
        )
    }()
    
    private lazy var logger: NetworkLogging = {
        NetworkLogger(
            isLogEnabled: environmentResolver
                .resolve(
                    environment
                ).isLoggingEnabled
        )
    }()

    public lazy var authManager: AuthManager = {
        AuthManager(
            tokenStore: tokenStore,
            httpClient: httpClient,
            environment: environment,
            resolver: environmentResolver,
            decoder: jsonDecoder,
            logger: logger
        ) { refreshToken in
            RefreshAppTokenEndpoint(
                refreshToken: refreshToken,
            )
        }
    }()

    private lazy var configuration: NetworkClientConfiguration = {
        NetworkClientConfiguration(
            environment: environment,
            resolver: environmentResolver,
            authManager: authManager,
            logger: logger,
            decoder: jsonDecoder
        )
    }()

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
