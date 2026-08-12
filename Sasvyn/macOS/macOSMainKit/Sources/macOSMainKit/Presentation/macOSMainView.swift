//
//  SwiftUIView.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
import ComposableArchitecture

public struct macOSMainView: View {
    let store: StoreOf<macOSMainFeature>
    
    public init(store: StoreOf<macOSMainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house") {
                Text("Home")
            }
            
            Tab.init("Profile", systemImage: "person") {
                Text("Profile")
            }
            
            Tab.init("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewSidebarBottomBar {
            Text("This is bottom bar")
        }
    }
}
