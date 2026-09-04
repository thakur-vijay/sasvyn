//
//  SwiftUIView.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
import ComposableArchitecture
import iOSPortfolioKit
import SVFoundation
import iOSProjectKit

public struct iOSHomeView: View {
    @Bindable var store: StoreOf<iOSHomeFeature>
    
    public init(store: StoreOf<iOSHomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20){
                    //                    FeaturedPortfolioCardView()
                    CreatePortfolioSection()
                    QuickActionsSection { action in
                        store.send(.quickAction(action))
                    }
                    RecentProjectsSection(
                        store: store.scope(
                            \.recentProjects,
                             action: \.recentProjects
                        )
                    )
                }
            }
            //            .ignoresSafeArea(.container, edges: .top)
            .navigationTitle("Welcome")
            .toolbarTitleDisplayMode(.inlineLarge)
            .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
                switch store.case {
                case .projectDetail(let store):
                    iOSProjectDetailView(store: store)
                        .interactiveDismissDisabled()
                }
            }
        }
    }
}
