//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture

@Reducer
public struct TechStackFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var mode: ProjectMode
        public init(mode: ProjectMode){
            self.mode = mode
        }
    }
    
    public enum Action {
        case modeChanged(ProjectMode)
    }
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            }
        }
    }
}
