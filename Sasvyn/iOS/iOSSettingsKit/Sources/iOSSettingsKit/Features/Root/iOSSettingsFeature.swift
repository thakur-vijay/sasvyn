//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import iOSPersonalInformationKit
import iOSAppearanceKit

@Reducer
public struct iOSSettingsFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public init(){
            
        }
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case alert(PresentationAction<Action.Alert>)
        case path(StackActionOf<Path>)
        case destinationTapped(SettingsDestination)
        case delegate(Delegate)
        
        public enum Delegate {
            case logoutSucceeded
        }
        
        public enum Alert {
            case signout
        }
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Path {
        case appearance(iOSAppearanceFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .delegate(_):
                return .none
            case .binding(_):
                return .none
            case .path(_):
                return .none
            case .destinationTapped(let destination):
                switch destination {
                case .signOut:
                    state.alert = AlertState {
                        TextState("Sign Out?")
                    } actions: {
                        ButtonState(
                            role: .destructive,
                            action: .signout
                        ) {
                            TextState("Sign out")
                        }
                        
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                    } message: {
                        TextState(
                            "Are you sure you want to sign out from the app?"
                        )
                    }
                case .personalInformation:
                    break
                case .appearance:
                    state.path.append(.appearance(.init()))
                case .privacy:
                    break
                case .termsOfService:
                    break
                case .helpAndSupport:
                    break
                }
                return .none
            case .alert(.presented(.signout)):
                state.alert = nil
                return .send(.delegate(.logoutSucceeded))
            case .alert(.dismiss):
                state.alert = nil
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSSettingsFeature.Path.State: Equatable {}
