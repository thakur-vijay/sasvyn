//
//  SasvynApp.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
#if os(macOS)
import macOSMainKit
#endif
import ComposableArchitecture
import SVDIInfra


@main
struct SasvynApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    private let appDIContainer = SVAppDIContainer()
    
    init() {
        AppDelegate.rootDIContainer = appDIContainer.rootDIContainer
        let customImage = UIImage(
            systemName: "chevron.left",
            withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)
        )?.withTintColor(.init(.accentColor), renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = customImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = customImage
    }

    var body: some Scene {
        WindowGroup {
#if os(macOS)
            macOSMainView(store: .init(initialState: macOSMainFeature.State(), reducer: {
                macOSMainFeature()
            }))
#elseif os(iOS)
            appDIContainer.rootDIContainer.makeView()
#endif
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)
        
    }
}
