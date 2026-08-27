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
        public var projectToDelete: Project? = nil
        public var path = StackState<Path.State>()
        public init(){
            
        }
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)
        case onTask
        case projectsLoaded([Project])
        case projectTapped(Project, ProjectMode)
        case createProjectTapped
        case deleteProjectTapped(Project)
        case projectDeleted(Project)
        
        public enum Alert {
            case deleteConfirmed
        }
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
            case .projectTapped(let project, let mode):
                state.path.append(.detail(iOSProjectDetailFeature.State(mode: mode, id: project.id)))
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
                state.projectToDelete = project
                state.alert = AlertState {
                    TextState("Delete Project?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .deleteConfirmed
                    ) {
                        TextState("Delete")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(
                        "Are you sure you want to delete \"\(project.name)\"?"
                    )
                }
                
                return .none
             
            case .alert(.presented(.deleteConfirmed)):
                guard let project = state.projectToDelete else {
                    return .none
                }

                state.projectToDelete = nil
                state.alert = nil
                return .run {[client] send in
                    do {
                        try await client.delete(project.id)
                        await send(.projectDeleted(project))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.projectToDelete = nil
                state.alert = nil
                return .none
            case .projectDeleted(let project):
                state.projects.removeAll { $0.id == project.id }
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSProjectsFeature.Path.State: Equatable { }

