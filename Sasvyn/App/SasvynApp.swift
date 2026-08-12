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
import iOSMainKit
#endif
import ComposableArchitecture

@main
struct SasvynApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            macOSMainView(store: .init(initialState: macOSMainFeature.State(), reducer: {
                macOSMainFeature()
            }))
            #elseif os(iOS)
            iOSMainView(store: .init(initialState: iOSMainFeature.State(), reducer: {
                iOSMainFeature()
            }))
            .preferredColorScheme(.dark)
            #endif
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)

    }
}

