import ComposableArchitecture
import SwiftUI

public struct iOSExperiencesView: View {
    @Bindable var store: StoreOf<iOSExperiencesFeature>

    public init(store: StoreOf<iOSExperiencesFeature>) { self.store = store }

    public var body: some View {
        List {
            ForEach(store.experiences) { experience in
                ExperienceCard(experience)
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("", systemImage: "pencil") {
                            store.send(.editTapped(experience))
                        }
                        .tint(.blue)
                        Button("", systemImage: "trash") {
                            store.send(.deleteTapped(experience))
                        }
                        .tint(.red)
                    }
            }
        }
        .listStyle(.plain)
        .overlay {
            if store.experiences.isEmpty {
                ContentUnavailableView(
                    "No Experience Added",
                    systemImage: "briefcase.fill",
                    description: Text("Add your work experience to showcase your professional journey.")
                )
            }
        }
        .navigationTitle("Experience")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") { store.send(.addTapped) }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { destinationStore in
            switch destinationStore.case {
            case .experienceForm(let formStore): ExperienceFormView(store: formStore)
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .task { await store.send(.onTask).finish() }
    }
}
