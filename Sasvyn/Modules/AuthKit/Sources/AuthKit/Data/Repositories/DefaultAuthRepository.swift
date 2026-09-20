//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit

internal final class DefaultAuthRepository: AuthRepository {
    private let remoteDataSource: AuthRemoteDataSource
    private let tokenStore: any TokenStore
    
    init(remoteDataSource: AuthRemoteDataSource, tokenStore: any TokenStore) {
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
    }
    
    
    func appleLogin(_ body: LoginRequestDTO) async throws-> User{
        let response = try await remoteDataSource.appleLogin(body)
        let accessToken = response.data.accessToken
        let refreshToken = response.data.refreshToken
        self.tokenStore.store(accessToken: accessToken, refreshToken: refreshToken)
        return response.data.user.toDomain()
    }
}
