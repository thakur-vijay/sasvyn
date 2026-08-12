//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSProjectsFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case projectTapped
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
            case .projectTapped:
                state.path.append(.detail(iOSProjectDetailFeature.State()))
                return .none
            case .binding(_):
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSProjectsFeature.Path.State: Equatable { }
