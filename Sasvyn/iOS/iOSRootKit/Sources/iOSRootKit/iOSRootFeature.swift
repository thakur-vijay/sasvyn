//
//  SwiftUIView.swift
//  iOSRootKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture
import iOSAuthKit
import iOSMainKit
import SVFoundation
import SVSpotlightKit

@Reducer
public struct iOSRootFeature {

    @ObservableState
    public enum State: Equatable {
        case auth(iOSAuthFeature.State)
        case main(iOSMainFeature.State)

        public static var initial: Self {
            .main(.init())
        }
    }

    public enum Action {
        case onAppear
        case auth(iOSAuthFeature.Action)
        case main(iOSMainFeature.Action)
        case quickAppAction(QuickAppAction)
        case spotlightAction(SVSpotlightDestination)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in

            switch action {

            case .auth(.delegate(.loginSucceeded)):
                state = .main(.init())
                return .none

            case .main(.delegate(.logoutSucceeded)):
                state = .auth(.init())
                return .none
            case .onAppear:
                return .none
            case .auth:
                return .none
            case .main:
                return .none
            case .quickAppAction(let action):
                return .send(.main(.quickAppAction(action)))
            case .spotlightAction(let action):
                return .send(.main(.spotlightAction(action)))
            }
        }
        .ifCaseLet(\.auth, action: \.auth) {
            iOSAuthFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            iOSMainFeature()
        }
    }
}
