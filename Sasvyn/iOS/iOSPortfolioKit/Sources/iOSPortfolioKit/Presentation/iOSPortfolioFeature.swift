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
