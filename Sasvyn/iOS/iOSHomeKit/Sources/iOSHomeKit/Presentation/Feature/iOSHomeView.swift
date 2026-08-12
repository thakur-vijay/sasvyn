//
//  SwiftUIView.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
import ComposableArchitecture
import iOSPortfolioKit
import SVRemoteImage

public struct iOSHomeView: View {
    let store: StoreOf<iOSHomeFeature>
    
    public init(store: StoreOf<iOSHomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20){
                    FeaturedPortfolioCardView()
                    RecentProjectsSection()
                }
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
}
