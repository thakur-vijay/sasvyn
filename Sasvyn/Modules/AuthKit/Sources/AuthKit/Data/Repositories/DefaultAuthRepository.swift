//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import SVNetwork

internal final class DefaultAuthRepository: AuthRepository {
    private let remoteDataSource: AuthRemoteDataSource
    private let tokenStore: any TokenStore
    private let appleLoginSaver: any AppleLoginStoring
    
    init(remoteDataSource: AuthRemoteDataSource, tokenStore: any TokenStore, appleLoginSaver: any AppleLoginStoring) {
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
        self.appleLoginSaver = appleLoginSaver
    }
    
    
    func appleLogin(_ body: SocialLoginRequest) async throws{
        if let email = body.email, let fullName = body.fullName {
            self.appleLoginSaver.saveAppleLoginResult(
                .init(
                    appleId: body.appleId,
                    email: email,
                    fullName: fullName
                )
            )
        }
        var updatedBody = body
        let savedAppleLoginInfo = try self.appleLoginSaver.appleLoginResult()
        updatedBody.appleId = savedAppleLoginInfo.appleId
        updatedBody.fullName = savedAppleLoginInfo.fullName
        updatedBody.email = savedAppleLoginInfo.email
        let response = try await remoteDataSource.appleLogin(updatedBody)
        let accessToken = response.data.accessToken
        let refreshToken = response.data.refreshToken
        let userId = response.data.user.id
        self.tokenStore.store(accessToken: accessToken, refreshToken: refreshToken)
        self.tokenStore.save(userId: userId)
    }
    
    func logout() async throws {
        try await remoteDataSource.logout()
        self.tokenStore.clearTokens()
    }
}
