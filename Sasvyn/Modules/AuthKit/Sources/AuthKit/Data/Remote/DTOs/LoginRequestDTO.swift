//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

public enum Provider: String, Encodable, Sendable{
    case apple
}

public struct SocialLoginRequest: Encodable, Sendable{
    public let provider: Provider
    public let identityToken: String?
    public let authorizationCode: String?
    public var appleId: String
    public var email: String?
    public var fullName: String?

    public init(
        provider: Provider,
        identityToken: String?,
        authorizationCode: String?,
        appleId: String,
        email: String?,
        fullName: String?
    ) {
        self.provider = provider
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
        self.appleId = appleId
        self.email = email
        self.fullName = fullName
    }
}
