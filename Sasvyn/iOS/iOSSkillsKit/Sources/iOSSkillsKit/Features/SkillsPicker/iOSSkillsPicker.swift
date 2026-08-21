//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVSkillsKit

public struct iOSSkillPicker: View {

    @Bindable var store: StoreOf<iOSSkillsPickerFeature>
    
    public init(
        store: StoreOf<iOSSkillsPickerFeature>,
    ) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(store.skillGroups.indices, id: \.self) { groupIndex in
                        let group = store.skillGroups[groupIndex]

                        SVSection(title: group.category.title) {
                            ChipLayoutUI(
                                alignment: .leading,
                                spacing: 10
                            ) {
                                ForEach(group.skills) { skill in
                                    SVChip(
                                        model: .init(
                                            id: skill.id,
                                            text: skill.skill
                                        ),
                                        isSelected: store.selectedSkillIDs.contains(skill.id)
                                    ) {
                                        store.send(.skillTapped(skill))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Skills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        store.send(.cancelTapped)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark") {
                        store.send(.saveTapped)
                    }
                }
            }
            .overlay {
                if store.skillGroups.isEmpty {
                    ContentUnavailableView(
                        "No Skills Yet",
                        systemImage: "square.grid.2x2",
                        description: Text(
                            "Add your skills to showcase your expertise."
                        )
                    )
                }
            }
            .task {
                await store.send(.onTask).finish()
            }
        }
    }
}
