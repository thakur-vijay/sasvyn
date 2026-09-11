//
//  SwiftUIView.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import ComposableArchitecture
import iOSHomeKit
import iOSProjectKit
import iOSLibraryKit
import iOSSettingsKit
import SVFoundation
import SVSpotlightKit

@Reducer
public struct iOSMainFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: TabModel = .home
        public var home = iOSHomeFeature.State()
        public var projects = iOSProjectsFeature.State()
        public var library = iOSLibraryFeature.State()
        public var settings = iOSSettingsFeature.State()
        
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case home(iOSHomeFeature.Action)
        case projects(iOSProjectsFeature.Action)
        case library(iOSLibraryFeature.Action)
        case settings(iOSSettingsFeature.Action)
        case quickAppAction(QuickAppAction)
        case spotlightAction(SVSpotlightDestination)
        
        case delegate(Delegate)
        
        public enum Delegate {
            case logoutSucceeded
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(\.home, action: \.home) {
            iOSHomeFeature()
        }
        Scope(\.projects, action: \.projects) {
            iOSProjectsFeature()
        }
        
        Scope(\.library, action: \.library) {
            iOSLibraryFeature()
        }
        
        Scope(\.settings, action: \.settings) {
            iOSSettingsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .settings(.delegate(.logoutSucceeded)):
                return .send(.delegate(.logoutSucceeded))
            case .binding(_):
                return .none
            case .projects(_):
                return .none
            case .library(_):
                return .none
            case .settings(_):
                return .none
            case .delegate(_):
                return .none
            case .home(.delegate(.addMockup(let image))):
                return .none
            case .home(_):
                return .none
            case .quickAppAction(let action):
                switch action {
                case .newProject:
                    return .send(.home(.quickAction(.addProject)))
                case .projects:
                    break
                case .createMockup:
                    return .send(.home(.quickAction(.createMockup)))
                case .exportPortfolio:
                    break
                }
                return .none
            case .spotlightAction(let action):
                switch action {
                case .skill:
                    state.selectedTab = .library
                    return .send(.library(.pathTapped(.skills)))
                case .project(_):
                    break
                case .experience(_):
                    break
                case .education(_):
                    break
                case .language(_):
                    break
                case .socialLink(id: let id):
                    break
                case .document(id: let id):
                    break
                }
                return .none
            }
        }
    }
}
