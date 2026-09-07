//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 07/09/26.
//

import ComposableArchitecture
import SVDesignSystem

@Reducer
public struct NameEditorFeature {
    @ObservableState
    public struct State: Equatable {
        public let userId: String
        public var firstName: String
        public var lastName: String
        
        public init(userId: String, firstName: String, lastName: String) {
            self.userId = userId
            self.firstName = firstName
            self.lastName = lastName
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
                firstName: String,
                lastName: String
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
                            firstName: state.firstName,
                            lastName: state.lastName
                        )
                    )
                )
            case .delegate(_):
                return .none
            }
        }
    }
}

extension NameEditorFeature.State {
    var isDetailsReady: Bool {
        return firstName.isNotEmpty && lastName.isNotEmpty
    }
}
