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
    
    @State private var isMusicPickerPresented: Bool = false
    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.projects){ project in
                        ProjectCard(project: project) {
                            store.send(.projectTapped(project))
                        } onDelete: {
                            store.send(.deleteProjectTapped(project))
                        }
                    }
                }
                .padding()
            }
            .overlay {
                if store.projects.isEmpty {
                    ContentUnavailableView(
                        "No Projects Yet",
                        systemImage: "square.stack.3d.up",
                        description: Text("Create a project to start building your portfolio.")
                    )
                }
            }
            .searchable(text: .constant(""), placement: .toolbar, prompt: Text("Search projects..."))
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "folder.badge.plus"){
                        store.send(.createProjectTapped)
                    }
                }
            }
            
        } destination: { store in
            switch store.case {
            case .detail(let store):
                iOSProjectDetailView(store: store)
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
