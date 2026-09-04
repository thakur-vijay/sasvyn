//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSProjectsView: View {
    @Bindable var store: StoreOf<iOSProjectsFeature>
    
    public init(store: StoreOf<iOSProjectsFeature>){
        self.store = store
    }
    
    @State private var isMusicPickerPresented: Bool = false
    @Namespace private var namespace
    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.projects){ project in
                        
                        ProjectCard(project: project) { mode in
                            store.send(.projectTapped(project, mode))
                        } onDelete: {
                            store.send(.deleteProjectTapped(project))
                        }
                        .contentShape(.contextMenuPreview, .rect)
                        .contextMenu {
                            Button("Edit", systemImage: "pencil") {
                                store.send(.projectTapped(project, .edit))
                            }
                            
                            Button("Delete", systemImage: "trash", role: .destructive){
                                store.send(.deleteProjectTapped(project))
                            }
                        }
                    }
                }
                .padding()
            }
            .overlay {
                if store.projects.isEmpty {
                    SVContentUnavailableView(
                        title: "No Projects Yet",
                        systemImage: "square.stack.3d.up",
                        description: "Create a project to start building your portfolio."
                    )
                }
            }
            .searchable(text: $store.search, placement: .toolbar, prompt: Text("Search projects..."))
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "folder.badge.plus"){
                        store.send(.createProjectTapped)
                    }
                }
            }
            .alert($store.scope(\.alert, action: \.alert))
            .onChange(of: store.search) { oldValue, newValue in
                store.send(.onTask)
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
