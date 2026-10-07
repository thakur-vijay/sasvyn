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
    private let fileUploader: any FileUploader
    private let metadataStore: any SyncMetadataStore

    public init(
        database: AppDatabase,
        networkClient: any NetworkClientProtocol,
        tokenStore: any TokenStore,
        fileUploader: any FileUploader,
        metadataStore: any SyncMetadataStore
    ) {
        self.database = database
        self.networkClient = networkClient
        self.tokenStore = tokenStore
        self.fileUploader = fileUploader
        self.metadataStore = metadataStore
    }

    private lazy var localDataSource: UsersLocalDataSource = {
        UsersLocalDataSource(database: database)
    }()

    private lazy var remoteDataSource: UsersRemoteDataSource = {
        UsersRemoteDataSource(
            client: networkClient,
            fileUploader: fileUploader
        )
    }()

    private lazy var syncEngine: any SyncEngine<User> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            metadataStore: metadataStore,
            conflictResolver: DefaultSyncConflictResolver<User>(strategy: .remoteWins)
        )
    }()

    private lazy var repository: UsersRepository = {
        DefaultUsersRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            tokenStore: tokenStore,
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
