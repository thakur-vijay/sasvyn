//
//  SwiftUIView.swift
//  iOSRootKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture
import macOSMainKit

@Reducer
public struct macOSRootFeature {

    @ObservableState
    public enum State: Equatable {
//        case auth(iOSAuthFeature.State)
        case main(macOSMainFeature.State)

        public static var initial: Self {
            .main(.init())
        }
    }

    public enum Action {
        case onAppear
//        case auth(iOSAuthFeature.Action)
        case main(macOSMainFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
//
//            case .auth(.delegate(.loginSucceeded)):
//                state = .main(.init())
//                return .none

//            case .main(.delegate(.logoutSucceeded)):
//                state = .auth(.init())
//                return .none
            case .onAppear:
                return .none
//            case .auth:
//                return .none
            case .main:
                return .none
            }
        }
//        .ifCaseLet(\.auth, action: \.auth) {
//            iOSAuthFeature()
//        }
        .ifCaseLet(\.main, action: \.main) {
            macOSMainFeature()
        }
    }
}
