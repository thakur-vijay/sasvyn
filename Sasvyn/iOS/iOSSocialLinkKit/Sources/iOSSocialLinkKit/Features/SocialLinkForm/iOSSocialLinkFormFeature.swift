//
//  File.swift
//  iOSSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import ComposableArchitecture
import SVSocialLinkKit
import SVFoundation

public enum SocialLinkFormMode: Sendable{
    case create
    case edit
}

@Reducer
public struct iOSSocialLinkFormFeature {
    
    @Dependency(\.socialLinksClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        let mode: SocialLinkFormMode
        var link: SocialLink
        var url: String = ""
        
        public init(mode: SocialLinkFormMode, link: SocialLink) {
            self.mode = mode
            self.link = link
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onTask
        case onLinkTypeChanged(LinkType)
        case linkEditingEnded
        case closeTapped
        case saveTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(SocialLink)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                state.url = state.link.url?.absoluteString ?? ""
                return .none
            case .binding(_):
                return .none
            case .onLinkTypeChanged(let type):
                state.link.type = type
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            case .saveTapped:
                let mode = state.mode
                let link = state.link
                return .run {[client] send in
                    do {
                        if mode == .create {
                            try await client.add(link)
                        }else {
                            try await client.update(link)
                        }
                        await send(.delegate(.update(link)))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            case .linkEditingEnded:
                state.link.url = .init(string: state.url)
                return .none
            }
        }
    }
}

extension iOSSocialLinkFormFeature.State {
    var isDetailsReady: Bool {
        return link.type != nil && (link.url?.isValid ?? false)
    }
}
