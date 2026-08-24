//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import ComposableArchitecture
import SVMockupKit

@Reducer
public struct iOSDevicePickerFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action {
        case closeTapped
        case deviceSelected(Device)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case deviceSelected(Device)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return .send(.delegate(.close))
            case .delegate(_):
                return .none
            case .deviceSelected(let device):
                return .send(.delegate(.deviceSelected(device)))
            }
        }
    }
}
