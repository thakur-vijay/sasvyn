//
//  SwiftUIView.swift
//  iOSAuthKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture
import AuthKit

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
        case onSignInWithAppleTap
        
        public enum Delegate {
            case loginSucceeded
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onSignInWithAppleTap:
//                return .send(.delegate(.loginSucceeded))
                let dto = LoginRequestDTO(appleId: "testing_apple_id_1", fullName: "Vijay Thakur", email: "thakurvijay0006@icloud.com")
                return .run { [client] send in
                    do {
                        try await client.signInWithApple(dto)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            }
        }
    }
}
