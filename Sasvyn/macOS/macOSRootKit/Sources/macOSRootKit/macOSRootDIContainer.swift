//
//  iOSRootDIContainer.swift
//  macOSRootKit
//
//  Created by Vijay Thakur on 14/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDIInfra

public final class macOSRootDIContainer {

    private let appDIContainer: SVAppDIContainer

    public init(appDIContainer: SVAppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    @MainActor
    private lazy var store: StoreOf<macOSRootFeature> = Store(
        initialState: macOSRootFeature.State.initial
    ) {
        macOSRootFeature()
    } withDependencies: {
        self.appDIContainer.addDependencies(&$0)
    }

    // MARK: - View

    @MainActor
    public func makeView() -> some View {
        macOSRootView(store: store)
            .frame(
                minWidth: 1200,
                minHeight: 800
            )
    }
}
