//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

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
                        Button(
                            "Edit",
                            systemImage: SVSymbols.edit.name
                        ) {
                            store.send(.editLanguageTapped(spokenLanguage))
                        }
                        
                        Button(
                            "Delete",
                            systemImage: SVSymbols.trash.name,
                            role: .destructive
                        ){
                            store.send(.deleteLanguageTapped(spokenLanguage))
                        }
                    }
                }
            }
            .padding(20)
        }
        .overlay {
            if store.languages.isEmpty {
                SVContentUnavailableView(
                    title: "No Languages Added",
                    symbol: SVSymbols.language,
                    description: "Add the languages you speak to showcase your communication skills."
                )
            }
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            SVToolbarItem(symbol: SVSymbols.Add.plain, placement: .topBarTrailing){
                store.send(.addLanguageTapped)
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .languageForm(let store):
                LanguageFormView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .task {
            await store.send(.onTask).finish()
        }
    }
}
