//
//  SwiftUIView.swift
//  iOSRootKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import SwiftUI
import ComposableArchitecture
import iOSAuthKit
import iOSMainKit
import iOSAppearanceKit

public struct iOSRootView: View {
    let store: StoreOf<iOSRootFeature>
    
    public init(store: StoreOf<iOSRootFeature>) {
        self.store = store
    }
    
    @AppStorage("appTint") private var appTint: AppTint = .blue
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    public var body: some View {
        switch store.state {
        case .auth:
            if let store = store.scope(\.auth, action: \.auth){
                iOSAuthView(store: store)
                    .tint(appTint.color)
                    .preferredColorScheme(appearanceMode.colorScheme())
            }
        case .main:
            if let store = store.scope(\.main, action: \.main){
                iOSMainView(store: store)
                    .tint(appTint.color)
                    .preferredColorScheme(appearanceMode.colorScheme())
                    .onChange(of: UITraitCollection.current.userInterfaceStyle) { _, newValue in
                        print(newValue)
                    }
            }
        }
    }
}
