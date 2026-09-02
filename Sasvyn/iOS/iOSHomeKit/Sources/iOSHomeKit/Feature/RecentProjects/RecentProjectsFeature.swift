//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 02/09/26.
//

import ComposableArchitecture
import SVProjectKit
import iOSProjectKit
import Foundation

@Reducer
public struct RecentProjectsFeature {
    @Dependency(\.projectsClient)
    private var projectsClient
    
    @ObservableState
    public struct State: Equatable {
        public var recentProjects: [Project] = []
        public init(){
            
        }
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        case onTask
        case recentProjectsLoaded([Project])
        case addProjectTapped
        case projectTapped(ProjectMode, Project.ID)
        case deleteProjectTapped(Project)
        case projectDeleted(Project.ID)
        case updateProject(Project)
        case delegate(Delegate)
        
        public enum Alert: Equatable{
            case deleteConfirmed(String)
        }
        
        public enum Delegate {
            case openProjectDetail(ProjectMode, Project.ID)
        }
    }

    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                return .merge(
                    .run { [projectsClient] send in
                        do {
                            let recentProjects = try await projectsClient.fetchRecent(5)
                            await send(.recentProjectsLoaded(recentProjects))
                        }catch {
                            print(error.localizedDescription)
                        }
                    }
                )
            case .recentProjectsLoaded(let recentProjects):
                state.recentProjects = recentProjects
                return .none
            case .binding(_):
                return .none
            case .addProjectTapped:
                return .send(.delegate(.openProjectDetail(.create, UUID().uuidString)))
            case let .projectTapped(mode, id):
                return .send(.delegate(.openProjectDetail(mode, id)))
            case .deleteProjectTapped(let project):
                state.alert = AlertState {
                    TextState("Delete Project?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .deleteConfirmed(project.id)
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
            case .alert(.presented(.deleteConfirmed(let id))):
                state.alert = nil
                return .run {[projectsClient] send in
                    do {
                        try await projectsClient.delete(id)
                        await send(.projectDeleted(id))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.alert = nil
                return .none
            case .projectDeleted(let projectID):
                state.recentProjects.removeAll { $0.id == projectID }
                return .none
            case .delegate(_):
                return .none
            case .updateProject(let project):
                if let index = state.recentProjects.firstIndex(where: { $0.id == project.id }){
                    state.recentProjects[index] = project
                }else {
                    state.recentProjects.append(project)
                }
                return .none
            }
        }
    }
}
