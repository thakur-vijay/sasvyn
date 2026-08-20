//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage

public struct iOSSettingsView: View {
    let store: StoreOf<iOSSettingsFeature>
    
    public init(store: StoreOf<iOSSettingsFeature>) {
        self.store = store
    }
    
    @State private var isSignOutAlertPresented: Bool = false
    public var body: some View {
        NavigationStack {
            List {
                VStack {
                    SVRemoteImage(
                        url: .init(
                            string: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D"
                        ),
                        side: 120,
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
                .listRowBackground(EmptyView())
                .frame(maxWidth: .infinity)
                
                Section {
                    NavigationLink(value: 0) {
                        Label("Personal Information", systemImage: "person.text.rectangle.fill")
                    }
                    
                    NavigationLink(value: 0) {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                    }
                }
    
                Section {
                    NavigationLink(value: 0) {
                        Label("Privacy", systemImage: "lock.shield.fill")
                    }
                    
                    NavigationLink(value: 0) {
                        Label("Terms of Service", systemImage: "doc.plaintext.fill")
                    }
                    
                    NavigationLink(value: 0) {
                        Label("Help & Support", systemImage: "questionmark.circle.fill")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        isSignOutAlertPresented.toggle()
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert("Sign Out", isPresented: $isSignOutAlertPresented) {
            Button("Sign Out", role: .destructive){
                store.send(.signoutTapped)
            }
        } message: {
            Text("Are you sure you want to sign out from the app?")
        }

    }
}
