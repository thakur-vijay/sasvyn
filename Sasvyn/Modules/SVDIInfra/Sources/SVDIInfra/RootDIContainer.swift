//
//  RootDIContainer.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 17/08/26.
//


import ComposableArchitecture
import SwiftUI
import SVSkillsKit
import iOSRootKit
import SVDocumentKit
import SVProjectKit
import SVMockupKit
import SVEducationKit
import SVExperienceKit
import SVLanguageKit
import SVSocialLinkKit
import SVSpotlightKit

@available(iOS 17.0, *)
public final class RootDIContainer {
    private let skillsDIContainer: SkillsDIContainer
    private let documentsDIContainer: DocumentsDIContainer
    private let projectsDIContainer: ProjectsDIContainer
    private let mockupsDIContainer: MockupsDIContainer
    private let educationsDIContainer: EducationsDIContainer
    private let experiencesDIContainer: ExperiencesDIContainer
    private let languagesDIContainer: LanguagesDIContainer
    private let socialLinksDIContainer: SocialLinksDIContainer
    private let spotlightDIContainer: SpotlightDIContainer
    public init(
        skillsDIContainer: SkillsDIContainer,
        documentsDIContainer: DocumentsDIContainer,
        projectsDIContainer: ProjectsDIContainer,
        mockupsDIContainer: MockupsDIContainer,
        educationsDIContainer: EducationsDIContainer,
        experiencesDIContainer: ExperiencesDIContainer,
        languagesDIContainer: LanguagesDIContainer,
        socialLinksDIContainer: SocialLinksDIContainer,
        spotlightDIContainer: SpotlightDIContainer
    ) {
        self.skillsDIContainer = skillsDIContainer
        self.documentsDIContainer = documentsDIContainer
        self.projectsDIContainer = projectsDIContainer
        self.mockupsDIContainer = mockupsDIContainer
        self.educationsDIContainer = educationsDIContainer
        self.experiencesDIContainer = experiencesDIContainer
        self.languagesDIContainer = languagesDIContainer
        self.socialLinksDIContainer = socialLinksDIContainer
        self.spotlightDIContainer = spotlightDIContainer
    }
    
    @MainActor
    private lazy var store: StoreOf<iOSRootFeature> = Store(initialState: iOSRootFeature.State.initial) {
        iOSRootFeature()
    } withDependencies: {
        self.skillsDIContainer.register(&$0)
        self.documentsDIContainer.register(&$0)
        self.projectsDIContainer.register(&$0)
        self.mockupsDIContainer.register(&$0)
        self.educationsDIContainer.register(&$0)
        self.experiencesDIContainer.register(&$0)
        self.languagesDIContainer.register(&$0)
        self.socialLinksDIContainer.register(&$0)
        self.spotlightDIContainer.register(&$0)
    }

    @MainActor public func makeView() -> some View {
        iOSRootView(store: store)
    }
    
    @MainActor
    public func send(_ action: iOSRootFeature.Action) {
        store.send(action)
    }
}
