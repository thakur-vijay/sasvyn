//
//  SwiftUIView.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import ComposableArchitecture

@Reducer
public struct iOSHomeFeature {
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

