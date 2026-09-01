//
//  File.swift
//  iOSSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI
import ComposableArchitecture
import SafariServices

public struct WebURL: Identifiable {
    public let id: String
    public let url: URL
    
    public init(id: String, url: URL) {
        self.id = id
        self.url = url
    }
}

public struct iOSSocialLinksView: View {
    @Bindable var store: StoreOf<iOSSocialLinksFeature>
    
    public init(store: StoreOf<iOSSocialLinksFeature>) {
        self.store = store
    }
    
    @State private var clickedURL: WebURL?
    public var body: some View {
        List {
            ForEach(store.links) { link in
                if let type = link.type, let url = link.url{
                    Button {
                        clickedURL = .init(id: link.id, url: url)
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
                ContentUnavailableView(
                    "No Links Added",
                    systemImage: "link",
                    description: Text("Add links to your portfolio, GitHub, LinkedIn, or other professional profiles.")
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
        .sheet(item: $clickedURL) { url in
            SafariView(url: url.url)
        }
        .alert($store.scope(\.alert, action: \.alert))
        .task {
            await store.send(.onTask).finish()
        }
    }
}

public struct SafariView: UIViewControllerRepresentable {

    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        return controller
    }

    public func updateUIViewController(
        _ viewController: SFSafariViewController,
        context: Context
    ) {
        // Nothing to update.
    }
}


