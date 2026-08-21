//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import iOSSkillsKit

internal struct TechStackView: View {
    @Bindable var store: StoreOf<TechStackFeature>
    
    init(store: StoreOf<TechStackFeature>) {
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Tech Stack") {
            ChipLayoutUI(alignment: .leading, spacing: 8) {
                ForEach(store.techStack) { stack in
                    SVChip(
                        model: .init(id: stack.id, text: stack.skill),
                        isSelected: false) {
                            
                        }
                        .contextMenu(isEnabled: store.mode.isEditable, shape: .capsule) {
                            Button("Delete", systemImage: "trash") {
                                store.send(.deleteStackTapped(stack))
                            }
                        }
                }
                
                if store.mode.isEditable {
                    SVChip(
                        model: .init(
                            id: "add",
                            text: "+ Add Stack"
                        ),
                        isSelected: false) {
                            store.send(.addStackTapped)
                        }
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .skillsPicker(let store):
                iOSSkillPicker(store: store)
            }
        }
    }
}

extension View {
    @ViewBuilder
    func contextMenu<MenuItems: View, S: Shape>(
        isEnabled: Bool,
        shape: S,
        @ContentBuilder menuItems: () -> MenuItems
    )-> some View {
        if isEnabled {
          self
                .contextMenu(menuItems: menuItems)
                .contentShape(.contextMenuPreview, shape)
        }else {
            self
        }
    }
}
