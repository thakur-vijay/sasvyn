//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import ComposableArchitecture
import SVLanguageKit
import Foundation

@Reducer
public struct iOSLanguagesFeature {
    
    @Dependency(\.languagesClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var languages: [SpokenLanguage] = []
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case addLanguageTapped
        case editLanguageTapped(SpokenLanguage)
        case deleteLanguageTapped(SpokenLanguage)
        case onTask
        case languagesLoaded([SpokenLanguage])
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case languageForm(LanguageFormFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .destination(.presented(.languageForm(.delegate(.update(let language))))):
                if let index = state.languages.firstIndex(where: { $0.id == language.id }){
                    state.languages[index] = language
                }else {
                    state.languages.append(language)
                }
                state.destination = nil
                return .none
            case .destination(.presented(.languageForm(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .addLanguageTapped:
                state.destination = .languageForm(
                    .init(
                        spokenLanguage: .init(
                            id: UUID().uuidString
                        ),
                        mode: .create
                    )
                )
                return .none
            case .editLanguageTapped(let language):
                state.destination = .languageForm(.init(spokenLanguage: language, mode: .edit))
                return .none
            case .deleteLanguageTapped(_):
                return .none
            case .onTask:
                return .run {[client] send in
                    do {
                        let languages = try await client.fetch()
                        await send(.languagesLoaded(languages))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .languagesLoaded(let languages):
                state.languages = languages
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSLanguagesFeature.Destination.State: Equatable {}
