//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSSkillsFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents
        public var destination: Destination.State?
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case addSkillsTapped
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case addSkills(iOSAddSkillsFeature)
    }
    
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addSkillsTapped:
                state.destination = .addSkills(iOSAddSkillsFeature.State())
                return .none
            case .binding(_):
                return .none
            case .destination(.presented(.addSkills(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSSkillsFeature.Destination.State: Equatable {}
