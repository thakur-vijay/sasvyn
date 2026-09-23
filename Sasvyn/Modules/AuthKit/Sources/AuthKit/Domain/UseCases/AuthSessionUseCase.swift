//
//  AuthSessionUseCase.swift
//  AuthKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import Foundation
import NetworkKit

public struct AuthSessionUseCase: Sendable{
    
    private let tokenStore: any TokenStore
    
    public init(tokenStore: any TokenStore) {
        self.tokenStore = tokenStore
    }
    
    public func execute() async -> AuthSession? {
        guard
            let userID = tokenStore.userId,
            let accessToken = tokenStore.accessToken,
            let refreshToken = tokenStore.refreshToken
        else {
            return nil
        }
        
        return AuthSession(userID: userID)
    }
}
