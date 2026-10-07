//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSkillsKit
import SVDocumentKit
import SVProjectKit
import SVMockupKit
import SVEducationKit
import SVExperienceKit
import SVLanguageKit
import SVSocialLinkKit
import SVSpotlightKit
import SVAboutKit
import ComposableArchitecture
import NetworkKit
import AuthKit
import SVPersonalInformationKit
import SVNetwork
import SVSyncKit
import SVRealtimeKit

public final class SVAppDIContainer {
    
    public init(){
        
    }
    
    lazy var networkContainer: SVNetworkDIContainer = {
        SVNetworkDIContainer()
    }()
    
    lazy var databaseContainer: SVDatabaseContainer = {
        SVDatabaseContainer()
    }()
    
    lazy var authDIContainer: AuthDIContainer = {
        AuthDIContainer(
            database: databaseContainer.appDatabase,
            tokenStore: networkContainer.tokenStore,
            networkClient: networkContainer.client,
            appleLoginSaver: networkContainer.appleLoginSaver,
            clientIDStore: networkContainer.clientIDStore
        )
    }()
    
    lazy var skillsDIContainer: SkillsDIContainer = {
        SkillsDIContainer(
            database: databaseContainer.appDatabase,
            networkClient: networkContainer.client,
            metadataStore: metadataStore
        )
    }()
    
    lazy var documentsDIContainer: DocumentsDIContainer = {
        DocumentsDIContainer(
            database: databaseContainer.appDatabase,
            metadataStore: metadataStore,
            networkClient: networkContainer.client,
            fileUploader: networkContainer.fileUploader
        )
    }()
      
    lazy var projectsDIContainer: ProjectsDIContainer = {
        ProjectsDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var mockupsDIContainer: MockupsDIContainer = {
        MockupsDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var educationsDIContainer: EducationsDIContainer = {
        EducationsDIContainer(database: databaseContainer.appDatabase)
    }()

    lazy var experiencesDIContainer: ExperiencesDIContainer = {
        ExperiencesDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var languagesDIContainer: LanguagesDIContainer = {
        LanguagesDIContainer(
            database: databaseContainer.appDatabase,
            networkClient: networkContainer.client,
            metadataStore: metadataStore
        )
    }()
    
    lazy var metadataStore: any SyncMetadataStore = {
        DefaultSyncMetadataStore(database: databaseContainer.appDatabase)
    }()
    
    lazy var socialLinksDIContianer: SocialLinksDIContainer = {
        SocialLinksDIContainer(
            database: databaseContainer.appDatabase,
            networkClient: networkContainer.client,
            metadataStore: metadataStore
        )
    }()
    
    lazy var spotlightDIContainer: SpotlightDIContainer = {
        SpotlightDIContainer()
    }()

    lazy var aboutDIContainer: AboutDIContainer = {
        AboutDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var personalInformationDIContainer: PersonalInformationDIContainer = {
        PersonalInformationDIContainer(
            database: databaseContainer.appDatabase,
            networkClient: networkContainer.client,
            tokenStore: networkContainer.tokenStore,
            fileUploader: networkContainer.fileUploader,
            metadataStore: metadataStore
        )
    }()
    
    lazy var realtimeDIContainer: RealtimeDIContainer = {
        RealtimeDIContainer(
            url: .init(string: "wss://api.vijaythakur.online/api/v1/ws")!,
            authManager: networkContainer.authManager,
            clientIDStore: networkContainer.clientIDStore
        )
    }()
    
    public func addDependencies(_ to: inout DependencyValues) {
        skillsDIContainer.register(&to)
        documentsDIContainer.register(&to)
        projectsDIContainer.register(&to)
        mockupsDIContainer.register(&to)
        educationsDIContainer.register(&to)
        experiencesDIContainer.register(&to)
        languagesDIContainer.register(&to)
        socialLinksDIContianer.register(&to)
        spotlightDIContainer.register(&to)
        aboutDIContainer.register(&to)
        authDIContainer.register(&to)
        personalInformationDIContainer.register(&to)
        realtimeDIContainer.register(&to)
    }
}
