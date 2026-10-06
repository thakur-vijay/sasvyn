//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture
import NetworkKit
import SVSyncKit

@available(iOS 26.0, macOS 15.0, *)
public final class SkillsDIContainer{

    private let database: AppDatabase
    private let networkClient: any NetworkClientProtocol
    private let metadataStore: any SyncMetadataStore

    public init(
        database: AppDatabase,
        networkClient: any NetworkClientProtocol,
        metadataStore: any SyncMetadataStore
    ) {
        self.database = database
        self.networkClient = networkClient
        self.metadataStore = metadataStore
    }

    private lazy var localDataSource: SkillsLocalDataSource = {
        SkillsLocalDataSource(database: database)
    }()
    
    private lazy var remoteDataSource: SkillsRemoteDataSource = {
        SkillsRemoteDataSource(client: networkClient)
    }()
    
    private lazy var syncEngine: any SyncEngine<Skill> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            metadataStore: metadataStore,
            conflictResolver: DefaultSyncConflictResolver(strategy: .remoteWins)
        )
    }()

    private lazy var repository: SkillsRepository = {
        DefaultSkillsRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            syncEngine: syncEngine
        )
    }()
    
    private lazy var addSkillUseCase: AddSkillUseCase = {
        AddSkillUseCase(repository: repository)
    }()
    
    private lazy var updateSkillUseCase: UpdateSkillUseCase = {
        UpdateSkillUseCase(repository: repository)
    }()
    
    private lazy var fetchSkillsUseCase: FetchSkillsUseCase = {
        FetchSkillsUseCase(repository: repository)
    }()
    
    private lazy var deleteSkillUseCase: DeleteSkillUseCase = {
        DeleteSkillUseCase(repository: repository)
    }()
    
    private lazy var client: SkillsClient = {
        SkillsClient.live(
            fetchSkillsUseCase: fetchSkillsUseCase,
            addSkillUseCase: addSkillUseCase,
            updateSkillUseCase: updateSkillUseCase,
            deleteSkillUseCase: deleteSkillUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.skillsClient = client
    }
    
}
