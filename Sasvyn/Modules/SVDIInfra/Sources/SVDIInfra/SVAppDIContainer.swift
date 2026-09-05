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

public final class SVAppDIContainer {
    
    public init(){
        
    }
    public lazy var databaseContainer: SVDatabaseContainer = {
        SVDatabaseContainer()
    }()
    
    lazy var skillsDIContainer: SkillsDIContainer = {
        SkillsDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var documentsDIContainer: DocumentsDIContainer = {
        DocumentsDIContainer(database: databaseContainer.appDatabase)
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
        LanguagesDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var socialLinksDIContianer: SocialLinksDIContainer = {
        SocialLinksDIContainer(database: databaseContainer.appDatabase)
    }()
    
    lazy var spotlightDIContainer: SpotlightDIContainer = {
        SpotlightDIContainer()
    }()
    
    public lazy var rootDIContainer: RootDIContainer = {
        RootDIContainer(
            skillsDIContainer: skillsDIContainer,
            documentsDIContainer: documentsDIContainer,
            projectsDIContainer: projectsDIContainer,
            mockupsDIContainer: mockupsDIContainer,
            educationsDIContainer: educationsDIContainer,
            experiencesDIContainer: experiencesDIContainer,
            languagesDIContainer: languagesDIContainer,
            socialLinksDIContainer: socialLinksDIContianer,
            spotlightDIContainer: spotlightDIContainer
        )
    }()
}
