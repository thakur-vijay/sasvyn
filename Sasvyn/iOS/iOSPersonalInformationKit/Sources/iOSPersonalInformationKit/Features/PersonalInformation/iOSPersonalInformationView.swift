//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVRemoteImage

public struct iOSPersonalInfomationView: View {
    let store: StoreOf<iOSPersonalInfomationFeature>
    
    public init(store: StoreOf<iOSPersonalInfomationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            SVRemoteImage(
                url: .init(string: ""),
                size: .init(width: 150, height: 150),
                contentMode: .fill,
                shape: .circle,
            )
            .clearListStyle()
        }
        .listStyle(.plain)
        .navigationTitle("Personal Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}
