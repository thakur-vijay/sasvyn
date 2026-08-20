//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSSettingsFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action {
        case signoutTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case logoutSucceeded
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signoutTapped:
                return .send(.delegate(.logoutSucceeded))
            case .delegate(_):
                return .none
            }
        }
    }
}
