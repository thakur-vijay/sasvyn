//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import ComposableArchitecture

@Reducer
public struct iOSPersonalInfomationFeature {
    
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
