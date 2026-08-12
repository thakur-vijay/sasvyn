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
            return .none
        }
    }
}
