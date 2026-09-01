//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import ComposableArchitecture
import SVLanguageKit

public enum LanguageFormMode: Sendable{
    case create
    case edit
}

@Reducer
public struct LanguageFormFeature {
    @Dependency(\.languagesClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var spokenLanguage: SpokenLanguage
        public let mode: LanguageFormMode
        
        public init(spokenLanguage: SpokenLanguage, mode: LanguageFormMode) {
            self.spokenLanguage = spokenLanguage
            self.mode = mode
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case closeTapped
        case saveTapped
        case selectLanguageTapped
        case proficiencyTapped(LanguageProficiency)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(SpokenLanguage)
        }
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case languagePicker(iOSLanguagePickerFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            case .saveTapped:
                let spokenLanguage = state.spokenLanguage
                return .run { [client] send in
                    do {
                        try await client.save(spokenLanguage)
                        await send(.delegate(.update(spokenLanguage)))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            case .destination(.presented(.languagePicker(.delegate(.update(let language))))):
                state.spokenLanguage.language = language.name
                state.spokenLanguage.languageCode = language.code
                state.destination = nil
                return .none
            case .destination(.presented(.languagePicker(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .selectLanguageTapped:
                state.destination = .languagePicker(.init(selection: state.spokenLanguage.languageCode))
                return .none
            case .proficiencyTapped(let proficiency):
                state.spokenLanguage.proficiency = proficiency
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension LanguageFormFeature.Destination.State: Equatable {}

extension LanguageFormFeature.State {
    var isDetailsReady: Bool {
        return spokenLanguage.language.isNotEmpty && spokenLanguage.languageCode.isNotEmpty
    }
}
