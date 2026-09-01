//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class SocialLinksDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: SocialLinksLocalDataSource = {
        SocialLinksLocalDataSource(database: database)
    }()

    private lazy var repository: SocialLinksRepository = {
        DefaultSocialLinksRepository(dataSource: dataSource)
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
