//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import iOSPersonalInformationKit
import iOSAppearanceKit
import SVPersonalInformationKit
import AuthKit

@Reducer
public struct iOSSettingsFeature {
    
    @Dependency(\.usersClient)
    private var usersClient
    
    @Dependency(\.authClient)
    private var authClient
    
    @ObservableState
    public struct State: Equatable {
//        var isCurrentUserFetched: Bool = false
        public var currentUser: User?
        public var path = StackState<Path.State>()
        public init(){
            
        }
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case onAppear
        case onCurrentUserFetched(User)
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
        case personalInformation(iOSPersonalInfomationFeature)
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
            case .path(.element(_, action: .personalInformation(.delegate(.update(let user))))):
                state.currentUser = user
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
                    guard let user = state.currentUser else { break }
                    state.path.append(.personalInformation(.init(user)))
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
                return .run {[authClient] send in
                    defer {
                        await send(.delegate(.logoutSucceeded))
                    }
                    do {
                        try await authClient.logout()
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.alert = nil
                return .none
            case .onAppear:
//                guard !state.isCurrentUserFetched else { return .none }
                return .run {[usersClient] send in
                    do {
                        let user = try await usersClient.fetchCurrentUser()
                        await send(.onCurrentUserFetched(user), animation: .smooth)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .onCurrentUserFetched(let user):
                state.currentUser = user
//                state.isCurrentUserFetched = true
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSSettingsFeature.Path.State: Equatable {}
