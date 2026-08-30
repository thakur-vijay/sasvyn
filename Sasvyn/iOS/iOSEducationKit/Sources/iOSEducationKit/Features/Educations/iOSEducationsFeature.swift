//
//  File.swift
//  iOSEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import ComposableArchitecture
import Foundation
import SVEducationKit

@Reducer
public struct iOSEducationsFeature {
    
    @Dependency(\.educationsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var educations: [Education] = []
        public var educationToDelete: Education? = nil
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case addTapped
        case editTapped(Education)
        case deleteTapped(Education)
        case educationDeleted(Education)
        case onTask
        case educationsLoaded([Education])
        
        public enum Alert {
            case deleteConfirmed
        }
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case educationForm(EducationFormFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .addTapped:
                state.destination = .educationForm(
                    .init(
                        education: .init(
                            id: UUID().uuidString
                        ),
                        mode: .create
                    )
                )
                return .none
            case .binding(_):
                return .none
            case .destination(.presented(.educationForm(.delegate(.update(let education))))):
                if let index = state.educations.firstIndex(where: { $0.id == education.id }){
                    state.educations[index] = education
                }else {
                    state.educations.append(education)
                }
                state.destination = nil
                return .none
            case .destination(.presented(.educationForm(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .editTapped(let education):
                state.destination = .educationForm(.init(education: education, mode: .edit))
                return .none
            case .deleteTapped(let education):
                state.educationToDelete = education
                state.alert = AlertState {
                    TextState("Delete Education?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .deleteConfirmed
                    ) {
                        TextState("Delete")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(
                        "Are you sure you want to delete \"\(education.degree)\"?"
                    )
                }
                
                return .none
             
            case .alert(.presented(.deleteConfirmed)):
                guard let education = state.educationToDelete else {
                    return .none
                }

                state.educationToDelete = nil
                state.alert = nil
                return .run {[client] send in
                    do {
                        try await client.delete(education.id)
                        await send(.educationDeleted(education), animation: .snappy)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.educationToDelete = nil
                state.alert = nil
                return .none
            case .onTask:
                return .run {[client] send in
                    do {
                        let educations = try await client.fetch()
                        await send(.educationsLoaded(educations))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .educationsLoaded(let educations):
                state.educations = educations
                return .none
            case .educationDeleted(let education):
                state.educations.removeAll { $0.id == education.id }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSEducationsFeature.Destination.State: Equatable {}
