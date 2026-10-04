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
public final class SocialLinksDIContainer{

    private let database: AppDatabase
    private let networkClient: any NetworkClientProtocol

    public init(database: AppDatabase, networkClient: any NetworkClientProtocol) {
        self.database = database
        self.networkClient = networkClient
    }

    private lazy var localDataSource: SocialLinksLocalDataSource = {
        SocialLinksLocalDataSource(database: database)
    }()
    
    private lazy var remoteDataSource: SocialLinksRemoteDataSource = {
        SocialLinksRemoteDataSource(client: networkClient)
    }()
    
    private lazy var syncEngine: any SyncEngine<SocialLink> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            conflictResolver: DefaultSyncConflictResolver<SocialLink>(strategy: .remoteWins),
        )
    }()

    private lazy var repository: SocialLinksRepository = {
        DefaultSocialLinksRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            syncEngine: syncEngine
        )
    }()
    
    private lazy var fetchSocialLinksUseCase: FetchSocialLinksUseCase = {
        FetchSocialLinksUseCase(repository: repository)
    }()
    
    private lazy var addSocialLinkUseCase: AddSocialLinkUseCase = {
        AddSocialLinkUseCase(repository: repository)
    }()
    
    private lazy var updateSocialLinkUseCase: UpdateSocialLinkUseCase = {
        UpdateSocialLinkUseCase(repository: repository)
    }()

    private lazy var deleteSocialLinkUseCase: DeleteSocialLinkUseCase = {
        DeleteSocialLinkUseCase(repository: repository)
    }()
    
    private lazy var client: SocialLinksClient = {
        SocialLinksClient.live(
            fetchSocialLinksUseCase: fetchSocialLinksUseCase,
            addSocialLinkUseCase: addSocialLinkUseCase,
            updateSocialLinkUseCase: updateSocialLinkUseCase,
            deleteSocialLinkUseCase: deleteSocialLinkUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.socialLinksClient = client
    }
    
}
