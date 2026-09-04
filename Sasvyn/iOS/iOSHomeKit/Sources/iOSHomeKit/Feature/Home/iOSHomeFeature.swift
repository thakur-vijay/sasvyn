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
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case recentProjects(RecentProjectsFeature.Action)
        case quickAction(QuickActionsSection.QuickAction)
    }
    
    @Reducer
    public enum Destination {
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
                state.destination = .projectDetail(.init(mode: mode, id: projectID, viewMode: .sheet))
                return .none
            case .recentProjects(_):
                return .none
            case .destination(.presented(.projectDetail(.delegate(.projectAdded(let project))))):
                state.destination = nil
                return .send(.recentProjects(.updateProject(project)))
            case .destination(.presented(.projectDetail(.delegate(.projectUpdated(let project))))):
                return .send(.recentProjects(.updateProject(project)))
            case .destination(.presented(.projectDetail(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .quickAction(let action):
                switch action {
                case .addDocument:
                    break
                case .createMockup:
                    break
                case .addProject:
                    state.destination = .projectDetail(.init(mode: .create, id: UUID().uuidString, viewMode: .sheet))
                case .editAbout:
                    break
                }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSHomeFeature.Destination.State: Equatable {}
