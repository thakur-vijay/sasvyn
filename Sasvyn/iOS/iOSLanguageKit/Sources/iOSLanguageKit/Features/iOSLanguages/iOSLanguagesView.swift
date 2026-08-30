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
        List {
            ForEach(store.languages) { spokenLanguage in
                VStack(alignment: .leading, spacing: 4) {
                    Text(spokenLanguage.language)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    Text(spokenLanguage.proficiency.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        store.send(.editLanguageTapped(spokenLanguage))
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                    
                    Button(role: .destructive) {
                        store.send(.deleteLanguageTapped(spokenLanguage))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
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
        .task {
            await store.send(.onTask).finish()
        }
    }
}
