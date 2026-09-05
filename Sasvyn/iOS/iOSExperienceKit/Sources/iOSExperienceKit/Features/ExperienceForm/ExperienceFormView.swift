import ComposableArchitecture
import SVDesignSystem
import SVExperienceKit
import SwiftUI

internal struct ExperienceFormView: View {
    @Bindable var store: StoreOf<ExperienceFormFeature>

    init(store: StoreOf<ExperienceFormFeature>) { self.store = store }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SVEditableText(
                        description: $store.experience.role,
                        placeholder: "Role",
                        isExpandable: false,
                        collapsedLineLimit: 1,
                        characterLimit: 100,
                        isEditable: true,
                        font: .callout,
                        onEditingEnded: {}
                    )
                    SVEditableText(
                        description: $store.experience.company,
                        placeholder: "Company",
                        isExpandable: false,
                        collapsedLineLimit: 1,
                        characterLimit: 100,
                        isEditable: true,
                        font: .callout,
                        onEditingEnded: {}
                    )
                }
                Section {
                    SVDatePicker("Start Date", selection: $store.experience.startDate)
                    Toggle("Currently Working", isOn: $store.experience.isCurrentlyWorking)
                    if !store.experience.isCurrentlyWorking {
                        SVDatePicker(
                            "End Date",
                            selection: Binding(
                                get: { store.experience.endDate ?? .now },
                                set: { store.send(.endDateChanged($0)) }
                            )
                        )
                    }
                }
                Section("Responsibilities") {
                    ForEach($store.experience.responsibilities) { $responsibility in
                        SVEditableText(
                            description: $responsibility.responsibility,
                            placeholder: "Responsibility",
                            isExpandable: true,
                            collapsedLineLimit: 1,
                            characterLimit: 300,
                            isEditable: true,
                            font: .callout,
                            onEditingEnded: {}
                        )
                    }
                    .onDelete { store.send(.deleteResponsibility($0)) }
                    Button(
                        "Add Responsibility",
                        systemImage: SVSymbols.Add.plain.name
                    ) {
                        store.send(
                            .addResponsibilityTapped
                        )
                    }
                }
            }
            .navigationTitle(store.mode == .create ? "Add Experience" : "Edit Experience")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
                SVToolbarItem.check(store.isDetailsReady) {
                    store.send(.saveTapped)
                }
            }
        }
    }
}
