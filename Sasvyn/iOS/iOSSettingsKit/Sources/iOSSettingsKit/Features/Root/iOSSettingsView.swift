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
import iOSPersonalInformationKit
import SVDesignSystem

public struct iOSSettingsView: View {
    @Bindable var store: StoreOf<iOSSettingsFeature>
    
    public init(store: StoreOf<iOSSettingsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            List {
                Section {
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
                    .clearListStyle()
                }
                
                Section {
                    ForEach(SettingsDestination.allCases) { destination in
                        SVListRow(
                            destination.rawValue,
                            leadingImage: destination.symbol.name,
                            isDestructive: destination.isDestructive
                        ) {
                            store.send(.destinationTapped(destination))
                        }
                    }
                }
            }
            .listSectionSpacing(.custom(20))
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)
        } destination: { store in
            switch store.case {
            case .appearance(let store):
                iOSAppearanceView(store: store)
            case .personalInformation(let store):
                iOSPersonalInfomationView(store: store)
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
    }
}
