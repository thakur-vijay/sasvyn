//
//  SwiftUIView.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import ComposableArchitecture
import SVProjectKit
import iOSProjectKit
import Foundation

@Reducer
public struct iOSHomeFeature {
    @ObservableState
    public struct State: Equatable {
        public var recentProjects = RecentProjectsFeature.State()
        public var path = StackState<Path.State>()
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case recentProjects(RecentProjectsFeature.Action)
    }
    
    @Reducer
    public enum Path {
        case projectDetail(iOSProjectDetailFeature)
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(\.recentProjects, action: \.recentProjects) {
            RecentProjectsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case let .recentProjects(.delegate(.openProjectDetail(mode, projectID))):
                state.path.append(.projectDetail(.init(mode: mode, id: projectID)))
                return .none
            case .recentProjects(_):
                return .none
            case .path(.element(_, action: .projectDetail(.delegate(.projectAdded(let project))))):
                return .send(.recentProjects(.updateProject(project)))
            case .path(.element(_, action: .projectDetail(.delegate(.projectUpdated(let project))))):
                return .send(.recentProjects(.updateProject(project)))
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSHomeFeature.Path.State: Equatable {}
