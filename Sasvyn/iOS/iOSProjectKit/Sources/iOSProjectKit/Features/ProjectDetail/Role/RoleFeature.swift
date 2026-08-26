//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import SVProjectKit

@Reducer
public struct RoleFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var role: String = ""
        public var mode: ProjectMode
        public init(mode: ProjectMode){
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case setData(_ role: String)
        case roleChanged
        case delegate(Delegate)
        
        public enum Delegate {
            case roleChanged
        }
    }
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            case .binding(_):
                return .none
            case .setData(let role):
                state.role = role
                return .none
            case .roleChanged:
                return .send(.delegate(.roleChanged))
            case .delegate(_):
                return .none
            }
        }
    }
}

internal extension RoleFeature.State{
    var isDetailsReady: Bool {
        role.isNotEmpty
    }
    
    func update(into project: inout Project) {
        project.role = role
    }
}
