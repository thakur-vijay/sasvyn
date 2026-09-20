//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

@preconcurrency import NetworkKit

public struct RefreshTokenEndpoint: Endpoint, Sendable{
    public typealias Response = RefreshTokenResponse
    
    public let path: String = "/auth/refresh"
    
    public let method: HTTPMethod = .post
    
    public let body: RequestBody?
    
    public init(refreshToken: String) {
        self.body = .json(RefreshTokenBody(refreshToken: refreshToken))
    }
}

public struct RefreshTokenBody: Encodable, Sendable{
    public let refreshToken: String
    
    public enum CondingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

public struct RefreshTokenResponse: Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    
    public enum CondingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
