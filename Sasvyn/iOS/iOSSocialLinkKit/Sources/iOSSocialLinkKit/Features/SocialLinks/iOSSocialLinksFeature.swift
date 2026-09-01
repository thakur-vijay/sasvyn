//
//  File.swift
//  iOSSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import ComposableArchitecture
import SVSocialLinkKit
import Foundation

@Reducer
public struct iOSSocialLinksFeature {
    
    @Dependency(\.socialLinksClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var links: [SocialLink] = []
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case onTask
        case linksLoaded([SocialLink])
        case addTapped
        case editLinkTapped(SocialLink)
        case deleteLinkTapped(SocialLink)
        case linkDeleted(String)
        
        public enum Alert: Equatable{
            case deleteConfirmed(String)
        }
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case socialLinkForm(iOSSocialLinkFormFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .onTask:
                return .run { [client] send in
                    do {
                        let links = try await client.fetch()
                        await send(.linksLoaded(links))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .addTapped:
                state.destination = .socialLinkForm(
                    .init(
                        mode: .create,
                        link: .init(
                            id: UUID().uuidString
                        )
                    )
                )
                return .none
            case .linksLoaded(let links):
                state.links = links
                return .none
            case .destination(.presented(.socialLinkForm(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(.presented(.socialLinkForm(.delegate(.update(let link))))):
                if let index = state.links.firstIndex(where: { $0.id == link.id }){
                    state.links[index] = link
                }else {
                    state.links.insert(link, at: 0)
                }
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .editLinkTapped(let link):
                state.destination = .socialLinkForm(
                    .init(
                        mode: .edit,
                        link: link
                    )
                )
                return .none
            case .deleteLinkTapped(let link):
                state.alert = AlertState {
                    TextState("Delete Link?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .deleteConfirmed(link.id)
                    ) {
                        TextState("Delete")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(
                        "Are you sure you want to delete this link?"
                    )
                }
                
                return .none
             
            case .alert(.presented(.deleteConfirmed(let linkID))):
                state.alert = nil
                return .run {[client] send in
                    do {
                        try await client.delete(linkID)
                        await send(.linkDeleted(linkID), animation: .snappy)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.alert = nil
                return .none
            case .linkDeleted(let linkID):
                state.links.removeAll { $0.id == linkID }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSSocialLinksFeature.Destination.State: Equatable {}
