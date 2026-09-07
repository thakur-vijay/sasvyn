//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 07/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct NameEditor: View {
    @Bindable var store: StoreOf<NameEditorFeature>
    
    public init(store: StoreOf<NameEditorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section("First") {
                SVEditableText(
                    description: $store.firstName,
                    placeholder: "Enter first name...",
                    isExpandable: false,
                    collapsedLineLimit: 1,
                    characterLimit: 50,
                    isEditable: true,
                    font: .callout) {
                        
                    }
            }
            
            Section("Last") {
                SVEditableText(
                    description: $store.lastName,
                    placeholder: "Enter last name...",
                    isExpandable: false,
                    collapsedLineLimit: 1,
                    characterLimit: 50,
                    isEditable: true,
                    font: .callout) {
                        
                    }
            }
        }
        .listSectionSpacing(.compact)
        .navigationTitle("Name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            SVToolbarItem.close {
                store.send(.closeTapped)
            }
            
            SVToolbarItem.check(store.isDetailsReady) {
                store.send(.saveTapped)
            }
        }
        .isASheet(true)
    }
}
