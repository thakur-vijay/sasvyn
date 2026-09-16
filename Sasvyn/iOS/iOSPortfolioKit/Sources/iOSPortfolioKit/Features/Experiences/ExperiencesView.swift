//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 15/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import iOSExperienceKit

internal struct ExperiencesView: View {
    @Bindable var store: StoreOf<ExperiencesFeature>
    
    init(store: StoreOf<ExperiencesFeature>) {
        self.store = store
    }
    
    var body: some View {
        List {
            ForEach(store.experiences) { experience in
                ExperienceCard(experience, mode: .screen, isSelected: false) {
                    store.send(.onEditExperienceTap(experience))
                } onDeleteTap: {
                    store.send(.onDeleteExperienceTap(experience))
                }
                .listRowSeparator(.visible, edges: .bottom)
                .listRowSeparator(.hidden, edges: .top)
            }
        }
        .listStyle(.plain)
        .overlay {
            if store.experiences.isEmpty {
                SVContentUnavailableView(
                    title: "No Experiences Yet",
                    symbol: SVSymbols.experience,
                    description: "Add an experience to start building your portfolio.") {
                        SVButton(
                            "Add Experience",
                            systemImage: SVSymbols.Add.plain.name,
                            size: .medium,
                            width: .intrinsic,
                            shape: .capsule) {
                                store.send(.onCreateExperienceTap)
                            }
                    }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)){ store in
            switch store.case {
            case .experienceForm(let store):
                ExperienceFormView(store: store)
                    .interactiveDismissDisabled()
            case .experiencePicker(let store):
                iOSExperiencesView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .overlay(alignment: .bottomTrailing){
            if !store.experiences.isEmpty{
                SVButton(
                    "Select",
                    systemImage: SVSymbols.Add.plain.name,
                    size: .medium,
                    width: .intrinsic,
                    shape: .capsule) {
                        store.send(.onSelectExperiencesTap)
                    }
                    .padding(SVSpacing.screen)
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
