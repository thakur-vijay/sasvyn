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

public struct iOSRootView: View {
    let store: StoreOf<iOSRootFeature>
    
    public init(store: StoreOf<iOSRootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        switch store.state {
        case .launching:
            Text("Launching Screen")
                .task {
                    store.send(.onAppear)
                }
        case .auth:
            if let store = store.scope(\.auth, action: \.auth){
                iOSAuthView(store: store)
            }
        case .main:
            if let store = store.scope(\.main, action: \.main){
                iOSMainView(store: store)
            }
        }
    }
}
