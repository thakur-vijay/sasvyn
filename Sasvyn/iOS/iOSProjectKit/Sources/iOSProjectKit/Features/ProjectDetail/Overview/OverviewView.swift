//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

struct OverviewView: View {
    @Bindable var store: StoreOf<OverviewFeature>
    
    init(store: StoreOf<OverviewFeature>) {
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Overview") {
            SVEditableText(
                description: $store.overview,
                placeholder: "Write overview...",
                collapsedLineLimit: 3,
                characterLimit: 300,
                isEditable: store.mode.isEditable,
                font: .body
            ) {
                    store.send(.overviewChanged)
                }
        }
    }
}
