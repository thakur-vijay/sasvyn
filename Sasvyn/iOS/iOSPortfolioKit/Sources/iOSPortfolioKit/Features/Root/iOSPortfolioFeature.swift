//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSPortfolioFeature {
    @ObservableState
    public struct State: Equatable {
        var selection: PortfolioSection? = .home
        
        public init(){
            
        }
        
        //sections
        var projects = ProjectsFeature.State()
        var experiences = ExperiencesFeature.State()
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onSectionTap(PortfolioSection)
        case closeTapped
        case saveTapped
        
        //sections
        case projects(ProjectsFeature.Action)
        case experiences(ExperiencesFeature.Action)
        
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case save
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(\.projects, action: \.projects) {
            ProjectsFeature()
        }
        Scope(\.experiences, action: \.experiences) {
            ExperiencesFeature()
        }
        Reduce { state, action in
            switch action {
            case .onSectionTap(let section):
                state.selection = section
                return .none
            case .binding(_):
                return .none
            case .projects, .experiences:
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            case .saveTapped:
                return .send(.delegate(.save))
            case .delegate(_):
                return .none
            }
        }
    }
}
