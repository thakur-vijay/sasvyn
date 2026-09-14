//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 14/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import iOSProjectKit

internal struct ProjectsView: View {
    @Bindable var store: StoreOf<ProjectsFeature>
    
    init(store: StoreOf<ProjectsFeature>) {
        self.store = store
    }
    
    var body: some View {
        List {
            ForEach(store.projects) { project in
                ProjectCard(project: project) { mode in
                    store.send(.onProjectTap(project.id, mode))
                } onDelete: {
                    store.send(.onDeleteProjectTap(project.id))
                }
                .listRowSeparator(.visible, edges: .bottom)
                .listRowSeparator(.hidden, edges: .top)
            }
        }
        .listStyle(.plain)
        .overlay {
            if store.projects.isEmpty {
                SVContentUnavailableView(
                    title: "No Projects Yet",
                    symbol: SVSymbols.Project.empty,
                    description: "Create a project to start building your portfolio.") {
                        SVButton(
                            "Create Project",
                            systemImage: SVSymbols.Add.plain.name,
                            size: .medium,
                            width: .intrinsic,
                            shape: .capsule) {
                                store.send(.onCreateProjectTap)
                            }
                    }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)){ store in
            switch store.case {
            case .projectDetail(let store):
                iOSProjectDetailView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .overlay(alignment: .bottomTrailing){
            if !store.projects.isEmpty{
                SVButton(
                    "Add",
                    systemImage: SVSymbols.Add.plain.name,
                    size: .medium,
                    width: .intrinsic,
                    shape: .capsule) {
                        
                    }
                    .padding(SVSpacing.screen)
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
