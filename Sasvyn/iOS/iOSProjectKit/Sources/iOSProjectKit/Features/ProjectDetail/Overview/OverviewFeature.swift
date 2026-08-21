//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture
import SVProjectKit

@Reducer
public struct OverviewFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var overview: String = ""
        public var mode: ProjectMode
        public init(mode: ProjectMode){
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case setData(_ overview: String)
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
            case .setData(let overview):
                state.overview = overview
                return .none
            }
        }
    }
}

internal extension OverviewFeature.State {
    var isDetailsReady: Bool {
        overview.isNotEmpty
    }
    
    func update(into project: inout Project) {
        project.overview = overview
    }
}
