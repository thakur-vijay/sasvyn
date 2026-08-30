//
//  File.swift
//  iOSLibraryKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import iOSSkillsKit
import iOSAboutKit
import iOSDocumentsKit
import iOSMockupKit
import iOSEducationKit
import iOSLanguageKit

@Reducer
public struct iOSLibraryFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        public var path = StackState<Path.State>()
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case pathTapped(LibraryDestination)
    }
    
    @Reducer
    public enum Path {
        case skills(iOSSkillsFeature)
        case about(iOSAboutFeature)
        case documents(iOSDocumentsFeature)
        case mockups(iOSMockupsFeature)
        case education(iOSEducationsFeature)
        case languages(iOSLanguagesFeature)
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .pathTapped(let destination):
                switch destination {
                case .skills: state.path.append(.skills(iOSSkillsFeature.State()))
                case .about: state.path.append(.about(iOSAboutFeature.State()))
                case .documents: state.path.append(.documents(iOSDocumentsFeature.State()))
                case .mockups: state.path.append(.mockups(.init(mode: .full)))
                case .education: state.path.append(.education(.init()))
                case .languages: state.path.append(.languages(.init()))
                default: break
                }
                return .none
            case .binding(_):
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension iOSLibraryFeature.Path.State: Equatable { }
