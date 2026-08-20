//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSSKillsView: View {
    @Bindable var store: StoreOf<iOSSkillsFeature>
    
    public init(store: StoreOf<iOSSkillsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.skillGroups.indices, id: \.self) { groupIndex in
                    let group = store.skillGroups[groupIndex]
                    SVSection(title: group.category.title){
                        ChipLayoutUI(alignment: .leading, spacing: 10) {
                            ForEach(group.skills) { skill in
                                SVChip(
                                    model: .init(id: skill.id, text: skill.skill),
                                    isSelected: false) {
                                        
                                    }
                                    .contextMenu {
                                        Button("Delete", systemImage: "trash") {
                                            store.send(.deleteSkillTapped(groupIndex, skill))
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    store.send(.addSkillsTapped)
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination)) { store in
            switch store.case {
            case .addSkills(let store):
                iOSAddSkillsSheet(store: store)
            }
        }
        .overlay {
            if store.skillGroups.isEmpty {
                ContentUnavailableView(
                    "No Skills Yet",
                    systemImage: "square.grid.2x2",
                    description: Text("Add your skills to showcase your expertise.")
                )
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
