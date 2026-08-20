//
//  SwiftUIView.swift
//  iOSAuthKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSAuthFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action {
        case delegate(Delegate)
        
        public enum Delegate {
            case loginSucceeded
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
