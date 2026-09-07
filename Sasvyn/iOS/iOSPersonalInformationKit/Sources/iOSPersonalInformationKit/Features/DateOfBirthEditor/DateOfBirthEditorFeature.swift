//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 07/09/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct DateOfBirthEditorFeature {
    @ObservableState
    public struct State: Equatable {
        public let userId: String
        public var dateOfBirth: Date
        
        public init(userId: String, dateOfBirth: Date) {
            self.userId = userId
            self.dateOfBirth = dateOfBirth
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case closeTapped
        case saveTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(
                userId: String,
                dateOfBirth: Date
            )
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            case .saveTapped:
                return .send(
                    .delegate(
                        .update(
                            userId: state.userId,
                            dateOfBirth: state.dateOfBirth
                        )
                    )
                )
            case .delegate(_):
                return .none
            }
        }
    }
}

extension DateOfBirthEditorFeature.State {
    var isDetailsReady: Bool {
        return true
    }
}
