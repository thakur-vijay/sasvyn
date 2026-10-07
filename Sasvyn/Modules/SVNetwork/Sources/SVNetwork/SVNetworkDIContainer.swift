//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import SVFoundation

public final class SVNetworkDIContainer {
    
    public init(){
        
    }

    private let defaultTokenStore = SVTokenStore()
    public lazy var client: NetworkClientProtocol = {
        NetworkClient(configuration: configuration)
    }()
    
    public lazy var tokenStore: TokenStore = defaultTokenStore
    
    public lazy var appleLoginSaver: AppleLoginStoring = defaultTokenStore
    
    public lazy var clientIDStore: ClientIDStoring = defaultTokenStore
    
    private lazy var requestInterceptors: [any RequestInterceptor] = [
        ClientIDInterceptor(clientIDStore: clientIDStore)
    ]
    
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
            requestInterceptors: requestInterceptors,
            logger: logger,
            decoder: jsonDecoder
        )
    }()

    private lazy var jsonDecoder: JSONDecoder = {
        SVJSONDecoder.make()
    }()
}

public extension HTTPHeader {
    static func idempotencyKey(_ key: String) -> HTTPHeader {
        .init(
            name: "Idempotency-Key",
            value: key
        )
    }
}

public final class ClientIDInterceptor: RequestInterceptor {

    private let clientIDStore: ClientIDStoring

    public init(clientIDStore: ClientIDStoring) {
        self.clientIDStore = clientIDStore
    }
    
    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request

        if let clientID = clientIDStore.clientID {
            request.setValue(
                clientID,
                forHTTPHeaderField: "X-Client-ID"
            )
        }

        return request
    }
    
}
