//
//  File.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//

@preconcurrency import NetworkKit
import Foundation

public struct RefreshAppTokenEndpoint: RefreshTokenEndpoint, Sendable{
  
    public typealias Response = RefreshTokenResponse
    
    public let path: String = "/auth/refresh"
    
    public let method: HTTPMethod = .post
    
    public let body: RequestBody?
    
    public var requiresAuth: Bool = false
    
    public init(refreshToken: String) {
        self.body = .json(RefreshTokenBody(refreshToken: refreshToken))
    }
    
    public func decodeTokenPair(_ data: Data, decoder: JSONDecoder) throws -> TokenPair {
        let response = try decoder.decode(RefreshTokenResponse.self, from: data)
        return .init(accessToken: response.data.accessToken, refreshToken: response.data.refreshToken)
    }
}

public struct RefreshTokenBody: Encodable, Sendable{
    public let refreshToken: String
    
    public enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

public struct RefreshTokenResponse: Codable, Sendable {
    let statusCode: Int
    let message: String
    let data: TokenResponse
}

public struct TokenResponse: Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String
}
