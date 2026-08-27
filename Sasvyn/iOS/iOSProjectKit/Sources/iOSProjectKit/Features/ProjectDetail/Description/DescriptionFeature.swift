//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 27/08/26.
//

import ComposableArchitecture
import SVProjectKit

@Reducer
public struct DescriptionFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var appDescription: String = ""
        public var mode: ProjectMode
        public init(mode: ProjectMode){
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case setData(_ description: String)
        case descriptionChanged
        case delegate(Delegate)
        
        public enum Delegate {
            case descriptionChanged
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
            case .setData(let description):
                state.appDescription = description
                return .none
            case .descriptionChanged:
                return .send(.delegate(.descriptionChanged))
            case .delegate(_):
                return .none
            }
        }
    }
}

internal extension DescriptionFeature.State {
    var isDetailsReady: Bool {
        appDescription.isNotEmpty
    }
    
    func update(into project: inout Project) {
        project.description = appDescription
    }
}
