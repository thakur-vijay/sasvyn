//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import NetworkKit

public struct EnvironmentResolver: AppEnvironmentResolving {

    public init() {}
    
    private let apiVersion = "/api/v1"

    public func resolve(
        _ environment: NetworkKit.AppEnvironment
    ) -> NetworkKit.AppEnvironmentConfig {

        switch environment {

        case .development:
            return .init(
                baseURL: "https://api.vijaythakur.online\(apiVersion)",
                isLoggingEnabled: true,
                urlCache: .shared
            )

        case .staging:
            return .init(
                baseURL: "https://api.vijaythakur.online\(apiVersion)",
                isLoggingEnabled: true,
                urlCache: .shared
            )

        case .production:
            return .init(
                baseURL: "https://api.vijaythakur.online\(apiVersion)",
                urlCache: .shared
            )

        case .custom:
            return .init(
                baseURL: "https://api.vijaythakur.online\(apiVersion)",
                urlCache: .shared
            )
        @unknown default:
            fatalError("Unsupported AppEnvironment")
        }
    }
}
