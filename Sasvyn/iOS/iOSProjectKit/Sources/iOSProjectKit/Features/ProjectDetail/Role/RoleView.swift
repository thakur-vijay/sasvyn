//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVProjectKit

struct RoleView: View {
    @Bindable var store: StoreOf<RoleFeature>
    
    init(store: StoreOf<RoleFeature>) {
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Role") {
            SVEditableText(
                description: $store.role,
                placeholder: "Enter role",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: ProjectConfiguration.Content.roleLimit,
                isEditable: store.mode.isEditable,
                font: .body
            ) {
                store.send(.roleChanged)
            }
        }
    }
}
