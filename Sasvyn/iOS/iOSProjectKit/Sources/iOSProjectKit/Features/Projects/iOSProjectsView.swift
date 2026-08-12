//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSProjectsView: View {
    @Bindable var store: StoreOf<iOSProjectsFeature>
    
    public init(store: StoreOf<iOSProjectsFeature>){
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(1...10, id: \.self){ _ in
                        ProjectCard {
                            store.send(.projectTapped)
                        }
                    }
                }
                .padding()
            }
            .searchable(text: .constant(""), placement: .toolbar, prompt: Text("Search projects..."))
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "folder.badge.plus"){}
                }
            }
        } destination: { store in
            switch store.case {
            case .detail(let store):
                iOSProjectDetailView(store: store)
            }
        }
    }
}
