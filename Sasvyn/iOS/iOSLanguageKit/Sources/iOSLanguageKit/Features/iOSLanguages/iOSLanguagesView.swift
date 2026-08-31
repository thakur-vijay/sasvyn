//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSLanguagesView: View {
    @Bindable var store: StoreOf<iOSLanguagesFeature>
    
    public init(store: StoreOf<iOSLanguagesFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(store.languages) { spokenLanguage in
                    GroupBox {
                        Text(spokenLanguage.proficiency.displayName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } label: {
                        Text(spokenLanguage.language)
                    }
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
                            store.send(.editLanguageTapped(spokenLanguage))
                        }
                        
                        Button("Delete", systemImage: "trash", role: .destructive){
                            store.send(.deleteLanguageTapped(spokenLanguage))
                        }
                    }
                }
            }
            .padding(20)
        }
        .overlay {
            if store.languages.isEmpty {
                ContentUnavailableView(
                    "No Languages Added",
                    systemImage: "character.bubble.fill",
                    description: Text("Add the languages you speak to showcase your communication skills.")
                )
            }
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.addLanguageTapped)
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Language")
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .languageForm(let store):
                LanguageFormView(store: store)
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .task {
            await store.send(.onTask).finish()
        }
    }
}
