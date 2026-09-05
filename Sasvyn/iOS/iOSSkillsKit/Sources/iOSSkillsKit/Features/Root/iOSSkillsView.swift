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
                                    model: .init(
                                        id: skill.id,
                                        text: skill.skill
                                    ),
                                    isSelected: store.selectedSkillIDs.contains(skill.id)
                                ) {
                                    if store.mode == .picker {
                                        store.send(.skillTapped(skill))
                                    }
                                }
                                .optionalContextMenu(store.mode == .screen, isPreviewHidden: true) {
                                    Button("Delete", systemImage: SVSymbols.trash.name) {
                                        store.send(.deleteSkillTapped(groupIndex, skill))
                                    }
                                } preview: {
                                    
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
            SVToolbarItem(symbol: SVSymbols.Add.plain, placement: .topBarTrailing) {
                store.send(.addSkillsTapped)
            }
            
            if store.mode == .picker {
                SVToolbarItem.close {
                    store.send(.cancelTapped)
                }
                
                SVToolbarItem.check {
                    store.send(.saveTapped)
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination)) { store in
            switch store.case {
            case .addSkills(let store):
                iOSAddSkillsSheet(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .overlay {
            if store.skillGroups.isEmpty {
                SVContentUnavailableView(
                    title: "No Skills Yet",
                    symbol: SVSymbols.skills,
                    description: "Add your skills to showcase your expertise."
                )
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
        .isASheet(store.mode == .picker)
    }
}
