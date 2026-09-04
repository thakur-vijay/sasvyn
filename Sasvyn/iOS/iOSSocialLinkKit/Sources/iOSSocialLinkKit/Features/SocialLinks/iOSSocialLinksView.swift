//
//  File.swift
//  iOSSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSSocialLinksView: View {
    @Bindable var store: StoreOf<iOSSocialLinksFeature>
    
    public init(store: StoreOf<iOSSocialLinksFeature>) {
        self.store = store
    }
    
    @State private var clickedWebItem: WebItem?
    public var body: some View {
        List {
            ForEach(store.links) { link in
                if let type = link.type, let url = link.url{
                    Button {
                        clickedWebItem = .init(url: url)
                    } label: {
                        NavigationLink(value: link) {
                            HStack(spacing: 12) {
                                type.icon
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(type.rawValue.capitalized)
                                        .font(.title3.bold())
                                    Text(url.absoluteString)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .listRowSeparator(.visible, edges: .bottom)
                    .listRowSeparator(.hidden, edges: .top)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("", systemImage: "applepencil.gen1"){
                            store.send(.editLinkTapped(link))
                        }
                        Button("", systemImage: "trash") {
                            store.send(.deleteLinkTapped(link))
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .listStyle(.plain)
        .overlay {
            if store.links.isEmpty {
                SVContentUnavailableView(
                    title: "No Links Added",
                    systemImage: "link",
                    description: "Add links to your portfolio, GitHub, LinkedIn, or other professional profiles."
                )
            }
        }
        .navigationTitle("Social Links")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.addTapped)
                } label: {
                    Image(systemName: "link.badge.plus")
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .socialLinkForm(let store):
                iOSSocialLinkFormView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .web($clickedWebItem)
        .alert($store.scope(\.alert, action: \.alert))
        .task {
            await store.send(.onTask).finish()
        }
    }
}
