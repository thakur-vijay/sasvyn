//
//  SwiftUIView.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
import ComposableArchitecture
import iOSHomeKit
import iOSProjectKit
import iOSLibraryKit
import iOSSettingsKit

public struct iOSMainView: View {
    @Bindable var store: StoreOf<iOSMainFeature>
    
    public init(store: StoreOf<iOSMainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: $store.selectedTab) {
            Tab(TabModel.home.rawValue, systemImage: TabModel.home.symbol.name, value: .home) {
                iOSHomeView(
                    store: store.scope(
                        \.home,
                         action: \.home
                    )
                )
            }
            
            Tab(TabModel.projects.rawValue, systemImage: TabModel.projects.symbol.name, value: .projects) {
                iOSProjectsView(
                    store: store.scope(
                        \.projects,
                         action: \.projects
                    )
                )
            }
            
            Tab(TabModel.library.rawValue, systemImage: TabModel.library.symbol.name, value: .library) {
                iOSLibraryView(
                    store: store.scope(
                        \.library,
                         action: \.library
                    )
                )
            }
            
            Tab(TabModel.settings.rawValue, systemImage: TabModel.settings.symbol.name, value: .settings) {
                iOSSettingsView(
                    store: store.scope(
                        \.settings,
                         action: \.settings
                    )
                )
            }
        }
//        .tint(.primary)
    }
}
