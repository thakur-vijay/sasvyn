//
//  SwiftUIView.swift
//  iOSRootKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import SwiftUI
import ComposableArchitecture
import macOSMainKit

public struct macOSRootView: View {
    let store: StoreOf<macOSRootFeature>
    
    public init(store: StoreOf<macOSRootFeature>) {
        self.store = store
    }
    
//    @AppStorage("appTint") private var appTint: AppTint = .azure
//
//    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    
    public var body: some View {
        switch store.state {
//        case .auth:
//            if let store = store.scope(\.auth, action: \.auth){
//                iOSAuthView(store: store)
//                    .tint(appTint.color)
//                    .preferredColorScheme(appearanceMode.colorScheme())
//            }
        case .main:
            if let store = store.scope(\.main, action: \.main){
                macOSMainView(store: store)
//                    .tint(appTint.color)
//                    .preferredColorScheme(appearanceMode.colorScheme())
            }
        }
    }
}
