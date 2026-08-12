//
//  SwiftUIView.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import ComposableArchitecture

@Reducer
public struct macOSMainFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action {
        
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
