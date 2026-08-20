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

@available(iOS 17.0, *)
public final class RootDIContainer {
    private let skillsDIContainer: SkillsDIContainer
    private let documentsDIContainer: DocumentsDIContainer
    private let projectsDIContainer: ProjectsDIContainer
    public init(
        skillsDIContainer: SkillsDIContainer,
        documentsDIContainer: DocumentsDIContainer,
        projectsDIContainer: ProjectsDIContainer
    ) {
        self.skillsDIContainer = skillsDIContainer
        self.documentsDIContainer = documentsDIContainer
        self.projectsDIContainer = projectsDIContainer
    }
    
    @MainActor
    private lazy var store: StoreOf<iOSRootFeature> = Store(initialState: iOSRootFeature.State.initial) {
        iOSRootFeature()
    } withDependencies: {
        self.skillsDIContainer.register(&$0)
        self.documentsDIContainer.register(&$0)
        self.projectsDIContainer.register(&$0)
    }

    @MainActor public func makeView() -> some View {
        iOSRootView(store: store)
    }
}
