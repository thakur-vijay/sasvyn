//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVLanguageKit
import SVDesignSystem

public struct iOSLanguagePicker: View {
    @Bindable var store: StoreOf<iOSLanguagePickerFeature>
    
    public init(store: StoreOf<iOSLanguagePickerFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(groupedLanguages, id: \.key) { group in
                        Section(group.key) {
                            ForEach(group.value) { language in
                                LabeledContent {
                                    if language.code == store.selection {
                                        SVSymbols.Check.plain.image
                                            .foregroundStyle(Color.accentColor)
                                    }
                                } label: {
                                    Text(language.name)
                                }
                                .id(language.code)
                                .contentShape(.rect)
                                .onTapGesture {
                                    store.send(.languageTapped(language))
                                }
                            }
                        }
                    }
                }
                .task {
                    await store.send(.onTask).finish()
                    await MainActor.run {
                        proxy.scrollTo(
                            store.selection,
                            anchor: .center
                        )
                    }
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
            }
            .searchable(
                text: $store.search,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(
                    "Search Language"
                )
            )
            .onChange(of: store.search) { _, newValue in
                store.send(.onSearchChanged)
            }
        }
    }
    
    private var groupedLanguages: [(key: String, value: [Language])] {
        Dictionary(grouping: store.filteredLanguages) {
            String($0.name.prefix(1)).uppercased()
        }
        .sorted { $0.key < $1.key }
    }
}
