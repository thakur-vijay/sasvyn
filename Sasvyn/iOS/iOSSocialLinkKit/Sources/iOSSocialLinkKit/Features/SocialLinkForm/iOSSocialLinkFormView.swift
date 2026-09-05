//
//  File.swift
//  iOSSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVSocialLinkKit

public struct iOSSocialLinkFormView: View {
    @Bindable var store: StoreOf<iOSSocialLinkFormFeature>
    
    public init(store: StoreOf<iOSSocialLinkFormFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section("Link") {
                    SVEditableText(
                        description: $store.url,
                        placeholder: "https://example.com",
                        isExpandable: false,
                        collapsedLineLimit: 1,
                        characterLimit: 500,
                        isEditable: true,
                        font: .body,
                        placeholderStyle: .secondary,
                        foregroundStyle: .primary,
                        contentType: .URL,
                        onEditingEnded: {
                            store.send(.linkEditingEnded)
                        }
                    )
                }
                Section("Link Type") {
                    ForEach(LinkType.allCases, id: \.self) { type in
                        
                        Button {
                            store.send(.onLinkTypeChanged(type))
                        } label: {
                            LabeledContent {
                                if store.link.type == type {
                                    SVSymbols.Check.plain.image
                                        .foregroundStyle(Color.accentColor)
                                }
                            } label: {
                                Label {
                                    Text(type.rawValue.capitalized)
                                } icon: {
                                    type.icon
                                        .frame(width: 24, height: 24)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.interactively)
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
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
    
    private var navigationTitle: String {
        store.mode == .create ? "Add Social Link" : "Edit Social Link"
    }
}
