//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSPortfolioView: View {
    @Bindable var store: StoreOf<iOSPortfolioFeature>
    
    public init(store: StoreOf<iOSPortfolioFeature>) {
        self.store = store
    }
    
    @State private var scrollPosition: ScrollPosition = .init()
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(PortfolioSection.allCases) { section in
                    switch section {
                    case .home:
                        PortfolioTabContent(section: section)
                            .id(section)
                            .containerRelativeFrame(.horizontal)
                    case .projects:
                        ProjectsView(
                            store: store.scope(
                                \.projects,
                                 action: \.projects
                            )
                        )
                        .id(section)
                        .containerRelativeFrame(.horizontal)
                    case .experiences:
                        ExperiencesView(
                            store: store.scope(
                                \.experiences,
                                 action: \.experiences
                            )
                        )
                        .id(section)
                        .containerRelativeFrame(.horizontal)
                    default:
                        PortfolioTabContent(section: section)
                            .id(section)
                            .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $store.selection, anchor: .center)
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaBar(edge: .top) {
            PortfolioSectionsView(sections: PortfolioSection.allCases, selection: $store.selection)
        }
        .toolbar {
            SVToolbarItem.close {
                store.send(.closeTapped)
            }
            
            SVToolbarItem.check(true) {
                store.send(.saveTapped)
            }
        }
        .isASheet(true)
    }
}

struct PortfolioTabContent: View {
    let section: PortfolioSection
    var body: some View {
        Rectangle()
            .overlay {
                Text(section.label)
                    .foregroundStyle(.white)
            }
    }
}
