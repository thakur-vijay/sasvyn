//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import SVProjectKit
import iOSProjectKit
import SVDesignSystem
import ComposableArchitecture

internal struct RecentProjectsSection: View {
    @Bindable var store: StoreOf<RecentProjectsFeature>
    
    init(store: StoreOf<RecentProjectsFeature>) {
        self.store = store
    }
    var body: some View {
        Group {
            if store.recentProjects.isNotEmpty {
                SVSection(title: "Recent Projects") {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 12) {
                            ForEach(store.recentProjects) { project in
                                RecentProjectCard(project: project) { mode in
                                    store.send(.projectTapped(mode, project.id))
                                } onDelete: {
                                    store.send(.deleteProjectTapped(project))
                                }
    
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollClipDisabled()
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .padding(.horizontal, 20)
                .alert($store.scope(\.alert, action: \.alert))
            }else {
                GroupBox {
                    SVContentUnavailableView(
                        title: "Add Your First Project",
                        symbol: SVSymbols.Project.projects,
                        description: "Showcase your best work and bring your portfolio to life.") {
                            SVButton(
                                "Add Project",
                                systemImage: SVSymbols.Project.Add.plain.name,
                                width: .intrinsic
                            ) {
                                store.send(.addProjectTapped)
                            }
                        }
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
