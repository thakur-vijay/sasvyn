//
//  RootDIContainer.swift
//  iOSRootKit
//
//  Created by Vijay Thakur on 13/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDIInfra

public final class iOSRootDIContainer {

    private let appDIContainer: SVAppDIContainer

    public init(appDIContainer: SVAppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    @MainActor
    private lazy var store: StoreOf<iOSRootFeature> = Store(
        initialState: iOSRootFeature.State.initial
    ) {
        iOSRootFeature()
    } withDependencies: {
        self.appDIContainer.addDependencies(&$0)
    }

    // MARK: - View

    @MainActor
    public func makeView() -> some View {
        iOSRootView(store: store)
    }

    @MainActor
    public func send(_ action: iOSRootFeature.Action) {
        store.send(action)
    }
}
