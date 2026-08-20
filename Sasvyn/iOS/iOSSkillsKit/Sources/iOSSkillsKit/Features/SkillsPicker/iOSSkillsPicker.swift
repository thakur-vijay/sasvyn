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

public extension View {

    func skillsPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Skill]>
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            iOSSkillPicker(
                store: Store(
                    initialState: .init(
                        selectedSkillIDs: Set(
                            selection.wrappedValue.map(\.id)
                        )
                    )
                ) {
                    iOSSkillsPickerFeature()
                },
                onCancel: {
                    isPresented.wrappedValue = false
                },
                onDone: { skills in
                    selection.wrappedValue = skills
                    isPresented.wrappedValue = false
                }
            )
        }
    }
}

internal struct iOSSkillPicker: View {

    @Bindable var store: StoreOf<iOSSkillsPickerFeature>

    let onCancel: () -> Void
    let onDone: ([Skill]) -> Void

    init(
        store: StoreOf<iOSSkillsPickerFeature>,
        onCancel: @escaping () -> Void,
        onDone: @escaping ([Skill]) -> Void
    ) {
        self.store = store
        self.onCancel = onCancel
        self.onDone = onDone
    }

    var body: some View {
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
                        onCancel()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark") {
                        onDone(store.selectedSkills)
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
