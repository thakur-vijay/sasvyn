//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVProjectKit
import Foundation

@Reducer
public struct iOSProjectsFeature {
    
    @Dependency(\.projectsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var search: String = ""
        public var projects: [Project] = []
        public var path = StackState<Path.State>()
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case onTask
        case projectsLoaded([Project])
        case projectTapped(Project)
        case createProjectTapped
        case deleteProjectTapped(Project)
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Path {
        case detail(iOSProjectDetailFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                let search = state.search
                return .run {[client] send in
                    do {
                        let projects = try await client.fetch(search)
                        await send(.projectsLoaded(projects))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .projectsLoaded(let projects):
                state.projects = projects
                return .none
            case .projectTapped(let project):
                state.path.append(.detail(iOSProjectDetailFeature.State(mode: .view, id: project.id)))
                return .none
            case .createProjectTapped:
                state.path.append(.detail(iOSProjectDetailFeature.State(mode: .create, id: UUID().uuidString)))
                return .none
            case .binding(_):
                return .none
            case .path(.element(_, action: .detail(.delegate(.projectAdded(let project))))):
                state.path.removeLast()
                state.projects.insert(project, at: 0)
                return .none
            case .path(.element(_, action: .detail(.delegate(.projectUpdated(let project))))):
                if let index = state.projects.firstIndex(where: { $0.id == project.id}){
                    state.projects[index] = project
                }
                return .none
            case .path(_):
                return .none
            case .deleteProjectTapped(let project):
                return .run {[client] send in
                    try await client.delete(project.id)
                }
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSProjectsFeature.Path.State: Equatable { }
