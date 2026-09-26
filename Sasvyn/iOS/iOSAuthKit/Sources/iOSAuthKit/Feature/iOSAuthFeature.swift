//
//  SwiftUIView.swift
//  iOSAuthKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture
import AuthKit
import SVNetwork

@Reducer
public struct iOSAuthFeature {
    
    @Dependency(\.authClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action {
        case delegate(Delegate)
        case appleLogin(SocialLoginRequest)
        case saveAppleLoginResult(AppleLoginResult)
        
        public enum Delegate {
            case loginSucceeded
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appleLogin(let body):
                return .run { [client, body] send in
                    do {
                        try await client.signInWithApple(body)
                        await send(.delegate(.loginSucceeded))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            case .saveAppleLoginResult(_):
                return .none
            }
        }
    }
}
