//
//  RootDIContainer.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 17/08/26.
//


//import ComposableArchitecture
//import SwiftUI
//import SVSkillsKit
//import SVDocumentKit
//import SVProjectKit
//import SVMockupKit
//import SVEducationKit
//import SVExperienceKit
//import SVLanguageKit
//import SVSocialLinkKit
//import SVSpotlightKit
//import SVAboutKit
//
//#if os(iOS)
//import iOSRootKit
//#elseif os(macOS)
//import macOSRootKit
//#endif
//
//@available(iOS 26.0, macOS 15.0, *)
//public final class RootDIContainer {
//
//    private let skillsDIContainer: SkillsDIContainer
//    private let documentsDIContainer: DocumentsDIContainer
//    private let projectsDIContainer: ProjectsDIContainer
//    private let mockupsDIContainer: MockupsDIContainer
//    private let educationsDIContainer: EducationsDIContainer
//    private let experiencesDIContainer: ExperiencesDIContainer
//    private let languagesDIContainer: LanguagesDIContainer
//    private let socialLinksDIContainer: SocialLinksDIContainer
//    private let spotlightDIContainer: SpotlightDIContainer
//    private let aboutDIContainer: AboutDIContainer
//
//    public init(
//        skillsDIContainer: SkillsDIContainer,
//        documentsDIContainer: DocumentsDIContainer,
//        projectsDIContainer: ProjectsDIContainer,
//        mockupsDIContainer: MockupsDIContainer,
//        educationsDIContainer: EducationsDIContainer,
//        experiencesDIContainer: ExperiencesDIContainer,
//        languagesDIContainer: LanguagesDIContainer,
//        socialLinksDIContainer: SocialLinksDIContainer,
//        spotlightDIContainer: SpotlightDIContainer,
//        aboutDIContainer: AboutDIContainer
//    ) {
//        self.skillsDIContainer = skillsDIContainer
//        self.documentsDIContainer = documentsDIContainer
//        self.projectsDIContainer = projectsDIContainer
//        self.mockupsDIContainer = mockupsDIContainer
//        self.educationsDIContainer = educationsDIContainer
//        self.experiencesDIContainer = experiencesDIContainer
//        self.languagesDIContainer = languagesDIContainer
//        self.socialLinksDIContainer = socialLinksDIContainer
//        self.spotlightDIContainer = spotlightDIContainer
//        self.aboutDIContainer = aboutDIContainer
//    }
//
//    private func addDependencies(_ to: inout DependencyValues) {
//        skillsDIContainer.register(&to)
//        documentsDIContainer.register(&to)
//        projectsDIContainer.register(&to)
//        mockupsDIContainer.register(&to)
//        educationsDIContainer.register(&to)
//        experiencesDIContainer.register(&to)
//        languagesDIContainer.register(&to)
//        socialLinksDIContainer.register(&to)
//        spotlightDIContainer.register(&to)
//        aboutDIContainer.register(&to)
//    }
//
//    // MARK: - Stores
//
//    #if os(iOS)
//
//    @MainActor
//    private lazy var iOSRootStore: StoreOf<iOSRootFeature> = Store(
//        initialState: iOSRootFeature.State.initial
//    ) {
//        iOSRootFeature()
//    } withDependencies: {
//        self.addDependencies(&$0)
//    }
//
//    #elseif os(macOS)
//
//    @MainActor
//    private lazy var macOSRootStore: StoreOf<macOSRootFeature> = Store(
//        initialState: macOSRootFeature.State()
//    ) {
//        macOSRootFeature()
//    } withDependencies: {
//        self.addDependencies(&$0)
//    }
//
//    #endif
//
//    // MARK: - View
//
//    @MainActor
//    public func makeView() -> some View {
//        #if os(iOS)
//        iOSRootView(store: iOSRootStore)
//        #elseif os(macOS)
//        macOSRootView(store: macOSRootStore)
//        #endif
//    }
//
//    // MARK: - iOS Actions
//
//    #if os(iOS)
//
//    @MainActor
//    public func send(_ action: iOSRootFeature.Action) {
//        iOSRootStore.send(action)
//    }
//
//    #endif
//}
