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
public final class LanguagesDIContainer{

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

    private lazy var localDataSource: LanguagesLocalDataSource = {
        LanguagesLocalDataSource(database: database)
    }()
    
    private lazy var remoteDataSource: LanguagesRemoteDataSource = {
        LanguagesRemoteDataSource(client: networkClient)
    }()
    
    private lazy var syncEngine: any SyncEngine<SpokenLanguage> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            metadataStore: metadataStore,
            conflictResolver: DefaultSyncConflictResolver(strategy: .remoteWins),
        )
    }()
    
    private lazy var repository: LanguagesRepository = {
        DefaultLanguagesRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            syncEngine: syncEngine
        )
    }()
    
    private lazy var loadLanguagesJSONUseCase: LoadLanguagesJSONUseCase = {
        LoadLanguagesJSONUseCase(repository: repository)
    }()
    
    private lazy var fetchSpokenLanguagesUseCase: FetchSpokenLanguagesUseCase = {
        FetchSpokenLanguagesUseCase(repository: repository)
    }()
    
    private lazy var addSpokenLanguageUseCase: AddSpokenLanguageUseCase = {
        AddSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var updateSpokenLanguageUseCase: UpdateSpokenLanguageUseCase = {
        UpdateSpokenLanguageUseCase(repository: repository)
    }()

    private lazy var deleteSpokenLanguageUseCase: DeleteSpokenLanguageUseCase = {
        DeleteSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var client: LanguagesClient = {
        LanguagesClient.live(
            loadLanguagesJSONUseCase: loadLanguagesJSONUseCase,
            fetchSpokenLanguagesUseCase: fetchSpokenLanguagesUseCase,
            addSpokenLanguageUseCase: addSpokenLanguageUseCase,
            updateSpokenLanguageUseCase: updateSpokenLanguageUseCase,
            deleteSpokenLanguageUseCase: deleteSpokenLanguageUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.languagesClient = client
    }
    
}
