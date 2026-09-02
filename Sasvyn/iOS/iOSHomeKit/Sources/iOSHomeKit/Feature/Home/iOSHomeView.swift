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

public struct iOSHomeView: View {
    let store: StoreOf<iOSHomeFeature>
    
    public init(store: StoreOf<iOSHomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20){
//                    FeaturedPortfolioCardView()
                    CreatePortfolioSection()
                    if store.recentProjects.isNotEmpty {
                        RecentProjectsSection(
                            projects: store.recentProjects
                        ) { project, mode in
                            
                        } onDelete: { project in
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }else {
                        CreateProjectSection()
                    }
                }
            }
//            .ignoresSafeArea(.container, edges: .top)
            .navigationTitle("Welcome")
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
