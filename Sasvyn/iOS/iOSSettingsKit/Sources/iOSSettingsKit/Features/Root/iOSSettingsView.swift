//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import iOSAppearanceKit

public struct iOSSettingsView: View {
    @Bindable var store: StoreOf<iOSSettingsFeature>
    
    public init(store: StoreOf<iOSSettingsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            List {
                VStack {
                    SVRemoteImage(
                        url: .init(
                            string: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D"
                        ),
                        size: .init(width: 120, height: 120),
                        shape: .circle
                    )
                    Text("Vijay Thakur")
                        .font(.largeTitle.bold())
                    Text("thakurvijay0006@gmail.com")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .tint(.gray)
                }
                .listStyle(.plain)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listRowBackground(EmptyView())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                ForEach(SettingsDestination.allCases) { destination in
                    Button {
                        store.send(.destinationTapped(destination))
                    } label: {
                        NavigationLink(value: destination) {
                            Label(
                                destination.rawValue,
                                systemImage: destination.symbol.name
                            )
                        }
                        .allowsHitTesting(false)
                        .navigationLinkIndicatorVisibility(destination.navigationLinkIndicatorVisibility)
                    }

                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)
        } destination: { store in
            switch store.case {
            case .appearance(let store):
                iOSAppearanceView(store: store)
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
    }
}
