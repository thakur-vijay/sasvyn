//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture
import NetworkKit
import SVNetwork

@available(iOS 26.0, macOS 15.0, *)
public final class AuthDIContainer{

    private let database: AppDatabase
    private let networkClient: any NetworkClientProtocol
    private let tokenStore: any TokenStore
    private let appleLoginSaver: any AppleLoginStoring

    public init(
        database: AppDatabase,
        tokenStore: any TokenStore,
        networkClient: any NetworkClientProtocol,
        appleLoginSaver: any AppleLoginStoring
    ) {
        self.database = database
        self.tokenStore = tokenStore
        self.networkClient = networkClient
        self.appleLoginSaver = appleLoginSaver
    }

    private lazy var authRemoteDataSource: AuthRemoteDataSource = {
        AuthRemoteDataSource(client: networkClient)
    }()

    private lazy var repository: AuthRepository = {
        DefaultAuthRepository(
            remoteDataSource: authRemoteDataSource,
            tokenStore: tokenStore,
            appleLoginSaver: appleLoginSaver
        )
    }()
    
    private lazy var signInWithAppleUseCase: SignInWithAppleUseCase = {
        SignInWithAppleUseCase(repository: repository)
    }()
    
    private lazy var authSessionUseCase: AuthSessionUseCase = {
        AuthSessionUseCase(tokenStore: tokenStore)
    }()
    
    private lazy var logoutUseCase: LogoutUseCase = {
        LogoutUseCase(repository: repository)
    }()

    private lazy var client: AuthClient = {
        AuthClient.live(
            signInWithAppleUseCase: signInWithAppleUseCase,
            authSessionUseCase: authSessionUseCase,
            logoutUseCase: logoutUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.authClient = client
    }
    
}
