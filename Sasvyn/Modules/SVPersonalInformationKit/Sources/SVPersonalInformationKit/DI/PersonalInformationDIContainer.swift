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
import SVSyncKit

@available(iOS 26.0, macOS 15.0, *)
public final class PersonalInformationDIContainer{

    private let database: AppDatabase
    private let networkClient: any NetworkClientProtocol
    private let tokenStore: any TokenStore
    private let imageUploader: any ImageUploader

    public init(
        database: AppDatabase,
        networkClient: any NetworkClientProtocol,
        tokenStore: any TokenStore,
        imageUploader: any ImageUploader
    ) {
        self.database = database
        self.networkClient = networkClient
        self.tokenStore = tokenStore
        self.imageUploader = imageUploader
    }

    private lazy var localDataSource: UsersLocalDataSource = {
        UsersLocalDataSource(database: database)
    }()

    private lazy var remoteDataSource: UsersRemoteDataSource = {
        UsersRemoteDataSource(client: networkClient)
    }()

    private lazy var syncEngine: any SyncEngine<User> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            conflictResolver: DefaultSyncConflictResolver<User>()
        )
    }()

    private lazy var repository: UsersRepository = {
        DefaultUsersRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            tokenStore: tokenStore,
            imageUploader: imageUploader,
            syncEngine: syncEngine
        )
    }()
    
    private lazy var fetchCurrentUserUseCase: FetchCurrentUserUseCase = {
        FetchCurrentUserUseCase(repository: repository)
    }()
    
    private lazy var updateUserUseCase: UpdateUserUseCase = {
        UpdateUserUseCase(repository: repository)
    }()
     
    private lazy var updateUserImageUseCase: UpdateUserImageUseCase = {
        UpdateUserImageUseCase(repository: repository)
    }()
    
    private lazy var client: UsersClient = {
        UsersClient.live(
            fetchCurrentUserUseCase: fetchCurrentUserUseCase,
            updateUserUseCase: updateUserUseCase,
            updateUserImageUseCase: updateUserImageUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.usersClient = client
    }
    
}
