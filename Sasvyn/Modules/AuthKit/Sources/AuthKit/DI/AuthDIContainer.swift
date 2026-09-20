//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture
import NetworkKit

@available(iOS 26.0, macOS 15.0, *)
public final class AuthDIContainer{

    private let database: AppDatabase
    private let networkClient: any NetworkClientProtocol
    private let tokenStore: any TokenStore

    public init(database: AppDatabase, tokenStore: any TokenStore, networkClient: any NetworkClientProtocol) {
        self.database = database
        self.tokenStore = tokenStore
        self.networkClient = networkClient
    }

    private lazy var authRemoteDataSource: AuthRemoteDataSource = {
        AuthRemoteDataSource(client: networkClient)
    }()

    private lazy var repository: AuthRepository = {
        DefaultAuthRepository(remoteDataSource: authRemoteDataSource, tokenStore: tokenStore)
    }()
    
    private lazy var signInWithAppleUseCase: SignInWithAppleUseCase = {
        SignInWithAppleUseCase(repository: repository)
    }()

    private lazy var client: AuthClient = {
        AuthClient.live(signInWithAppleUseCase: signInWithAppleUseCase)
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.authClient = client
    }
    
}
