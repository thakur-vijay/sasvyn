//
//  File.swift
//  iOSLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import ComposableArchitecture
import SVLanguageKit

@Reducer
public struct iOSLanguagePickerFeature {
    
    @Dependency(\.languagesClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var languages: [Language] = []
        public var search: String = ""
        public var filteredLanguages: [Language] = []
        public var selection: String?
        public init(selection: String? = nil){
            self.selection = selection
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case onLanguagesLoaded([Language])
        case onSearchChanged
        case languageTapped(Language)
        case closeTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(Language)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run {[client] send in
                    do {
                        let languages = try await client.loadLanguages()
                        await send(.onLanguagesLoaded(languages))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .onLanguagesLoaded(let languages):
                state.languages = languages
                state.filteredLanguages = languages
                return .none
            case .onSearchChanged:
                guard state.search.isNotEmpty else {
                    state.filteredLanguages = state.languages
                    return .none
                }

                let search = state.search.lowercased()

                state.filteredLanguages = state.languages.filter { language in
                    language.name.lowercased().contains(search) ||
                    language.code.lowercased().contains(search)
                }

                return .none
            case .binding(_):
                return .none
            case .languageTapped(let language):
                return .send(.delegate(.update(language)))
            case .closeTapped:
                return .send(.delegate(.close))
            case .delegate(_):
                return .none
            }
        }
    }
}
