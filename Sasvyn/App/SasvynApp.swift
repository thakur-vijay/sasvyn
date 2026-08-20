//
//  SasvynApp.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
#if os(macOS)
import macOSMainKit
#elseif os(iOS)
import iOSRootKit
#endif
import ComposableArchitecture
import SVDIInfra

@main
struct SasvynApp: App {
    private let appDIContainer = SVAppDIContainer()
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            macOSMainView(store: .init(initialState: macOSMainFeature.State(), reducer: {
                macOSMainFeature()
            }))
#elseif os(iOS)
            appDIContainer.rootDIContainer.makeView()
                .preferredColorScheme(.dark)
#endif
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)
        
    }
}

