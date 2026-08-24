//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import ComposableArchitecture
import SVMockupKit

@Reducer
public struct iOSMockupsFeature {
    
    @Dependency(\.mockupsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var mockups: [MockupImage] = []
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case addTapped
        case onTask
        case mockupsReady([MockupImage])
        case deleteTapped(MockupImage)
        case mockupDeleted(MockupImage)
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case iOSCreateMockup(iOSCreateMockupFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .addTapped:
                state.destination = .iOSCreateMockup(.init())
                return .none
            case .onTask:
                return .run {[client] send in
                    do {
                        let mockups = try await client.fetch()
                        await send(.mockupsReady(mockups))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .mockupsReady(let mockups):
                state.mockups = mockups
                return .none
            case .destination(.presented(.iOSCreateMockup(.delegate(.addMockup(let newMockup))))):
                state.mockups.append(newMockup)
                return .none
            case .destination(.presented(.iOSCreateMockup(.delegate(.exportFinished)))),
                 .destination(.presented(.iOSCreateMockup(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            case .deleteTapped(let mockup):
                return .run {[client] send in
                    do {
                        try await client.delete(mockup.id)
                        await send(.mockupDeleted(mockup))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .mockupDeleted(let mockup):
                state.mockups.removeAll { $0.id == mockup.id }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSMockupsFeature.Destination.State: Equatable {}
