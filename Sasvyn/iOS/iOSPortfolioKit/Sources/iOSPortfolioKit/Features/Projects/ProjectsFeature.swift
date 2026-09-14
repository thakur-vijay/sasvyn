//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 14/09/26.
//

import ComposableArchitecture
import iOSProjectKit
import SVProjectKit
import Foundation

@Reducer
public struct ProjectsFeature {
    
    @Dependency(\.projectsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        var projects: [Project] = []
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case onProjectsLoaded([Project])
        case destination(PresentationAction<Destination.Action>)
        case onCreateProjectTap
        case onAddProjectsTap
        case onProjectTap(Project.ID, ProjectMode)
        case onDeleteProjectTap(Project.ID)
        
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case projectDetail(iOSProjectDetailFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run {[client] send in
                    do {
                        let projects = try await client.fetch("")
                        await send(.onProjectsLoaded(projects))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .onProjectsLoaded(let projects):
                state.projects = projects
                return .none
            case .onCreateProjectTap:
                state.destination = .projectDetail(.init(mode: .create, id: UUID().uuidString, viewMode: .sheet))
                return .none
            case .onAddProjectsTap:
                return .none
            case let .onProjectTap(projectId, mode):
                state.destination = .projectDetail(.init(mode: mode, id: projectId, viewMode: .sheet))
                return .none
            case .onDeleteProjectTap(let projectId):
                state.projects.removeAll { $0.id == projectId }
                return .none
            case .destination(.presented(.projectDetail(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(.presented(.projectDetail(.delegate(.projectAdded(let project))))):
                state.projects.append(project)
                state.destination = nil
                return .none
            case .destination(.presented(.projectDetail(.delegate(.projectUpdated(let project))))):
                if let index = state.projects.firstIndex(where: { $0.id == project.id }){
                    state.projects[index] = project
                }
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .binding(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ProjectsFeature.Destination.State: Equatable {}
