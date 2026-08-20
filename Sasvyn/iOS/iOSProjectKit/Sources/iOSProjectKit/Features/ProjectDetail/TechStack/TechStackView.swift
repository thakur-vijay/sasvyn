//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

internal struct TechStackView: View {
    let store: StoreOf<TechStackFeature>
    
    init(store: StoreOf<TechStackFeature>) {
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Tech Stack") {
            ChipLayoutUI(alignment: .leading, spacing: 8) {
                ForEach(["SwiftUI", "MVVM", "StoreKit", "Socket.IO", "Firebase"], id: \.self) { tech in
                    Text(tech)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6), in: .capsule)
                        .contextMenu(isEnabled: store.mode.isEditable, shape: .capsule) {
                            Button("Delete", systemImage: "trash") {
                                
                            }
                        }
                }
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
