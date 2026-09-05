//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVLanguageKit

public struct LanguageFormView: View {
    @Bindable var store: StoreOf<LanguageFormFeature>
    
    public init(store: StoreOf<LanguageFormFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section("Language"){
                    Text(store.spokenLanguage.language.isEmpty ? "Select Language" : store.spokenLanguage.language)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(.rect)
                        .onTapGesture {
                            store.send(.selectLanguageTapped)
                        }
                }
                
                Section("Proficiency") {
                    ForEach(LanguageProficiency.allCases, id: \.self) { proficiency in
                        LabeledContent {
                            if store.spokenLanguage.proficiency == proficiency {
                                SVSymbols.Check.plain.image
                                    .foregroundStyle(Color.accentColor)
                            }
                        } label: {
                            Text(proficiency.displayName)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            store.send(.proficiencyTapped(proficiency))
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
                
                SVToolbarItem.check(store.isDetailsReady) {
                    store.send(.saveTapped)
                }
                
            }
            .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
                switch store.case {
                case .languagePicker(let store):
                    iOSLanguagePicker(store: store)
                        .interactiveDismissDisabled()
                }
            }
        }
    }
    
    private var navigationTitle: String {
        store.mode == .create ? "Add Language" : "Edit Language"
    }
}
