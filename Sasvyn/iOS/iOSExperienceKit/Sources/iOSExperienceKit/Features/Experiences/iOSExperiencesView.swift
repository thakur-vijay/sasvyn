import ComposableArchitecture
import SwiftUI
import SVDesignSystem

public enum ExperienceViewMode {
    case screen
    case picker
}

public struct iOSExperiencesView: View {
    @Bindable var store: StoreOf<iOSExperiencesFeature>

    public init(store: StoreOf<iOSExperiencesFeature>) { self.store = store }

    public var body: some View {
        List {
            ForEach(store.experiences) { experience in
                ExperienceCard(
                    experience,
                    mode: store.mode,
                    isSelected: store.selectedExperiencesIDs.contains(experience.id)) {
                        store.send(.editTapped(experience))
                    } onDeleteTap: {
                        store.send(.deleteTapped(experience))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("", systemImage: SVSymbols.edit.name) {
                            store.send(.editTapped(experience))
                        }
                        Button("", systemImage: SVSymbols.trash.name) {
                            store.send(.deleteTapped(experience))
                        }
                        .tint(.red)
                    }
            }
        }
        .overlay {
            if store.experiences.isEmpty {
                SVContentUnavailableView(
                    title: "No Experience Added",
                    symbol: SVSymbols.experience,
                    description: "Add your work experience to showcase your professional journey."
                )
            }
        }
        .navigationTitle("Experience")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if store.mode == .picker {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
            }
            SVToolbarItem(symbol: SVSymbols.Add.plain, placement: .topBarTrailing) {
                store.send(.addTapped)
            }
            
            if store.mode == .picker {
                SVToolbarItem.check {
                    store.send(.saveTapped)
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { destinationStore in
            switch destinationStore.case {
            case .experienceForm(let formStore):
                ExperienceFormView(store: formStore)
                    .interactiveDismissDisabled()
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .isASheet(store.mode == .picker)
        .task { await store.send(.onTask).finish() }
    }
}
