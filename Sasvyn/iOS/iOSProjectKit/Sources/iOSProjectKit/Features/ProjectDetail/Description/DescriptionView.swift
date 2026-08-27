//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 27/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVProjectKit

struct DescriptionView: View {
    @Bindable var store: StoreOf<DescriptionFeature>
    
    init(store: StoreOf<DescriptionFeature>) {
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Description") {
            SVEditableText(
                description: $store.appDescription,
                placeholder: "Write description...",
                collapsedLineLimit: 4,
                characterLimit: ProjectConfiguration.Content.descriptionLimit,
                isEditable: store.mode.isEditable,
                font: .callout
            ) {
                store.send(.descriptionChanged)
            }
        }
    }
}

