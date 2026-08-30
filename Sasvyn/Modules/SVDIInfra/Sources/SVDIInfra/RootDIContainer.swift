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
import SVLanguageKit

@available(iOS 17.0, *)
public final class RootDIContainer {
    private let skillsDIContainer: SkillsDIContainer
    private let documentsDIContainer: DocumentsDIContainer
    private let projectsDIContainer: ProjectsDIContainer
    private let mockupsDIContainer: MockupsDIContainer
    private let educationsDIContainer: EducationsDIContainer
    private let languagesDIContainer: LanguagesDIContainer
    public init(
        skillsDIContainer: SkillsDIContainer,
        documentsDIContainer: DocumentsDIContainer,
        projectsDIContainer: ProjectsDIContainer,
        mockupsDIContainer: MockupsDIContainer,
        educationsDIContainer: EducationsDIContainer,
        languagesDIContainer: LanguagesDIContainer
    ) {
        self.skillsDIContainer = skillsDIContainer
        self.documentsDIContainer = documentsDIContainer
        self.projectsDIContainer = projectsDIContainer
        self.mockupsDIContainer = mockupsDIContainer
        self.educationsDIContainer = educationsDIContainer
        self.languagesDIContainer = languagesDIContainer
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
        self.languagesDIContainer.register(&$0)
    }

    @MainActor public func makeView() -> some View {
        iOSRootView(store: store)
    }
}
