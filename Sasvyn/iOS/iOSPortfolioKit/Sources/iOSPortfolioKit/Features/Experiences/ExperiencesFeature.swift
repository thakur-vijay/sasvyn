//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 15/09/26.
//

import ComposableArchitecture
import iOSExperienceKit
import SVExperienceKit
import Foundation

@Reducer
public struct ExperiencesFeature {
    
    @Dependency(\.experiencesClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        var experiences: [Experience] = []
        
        @Presents
        public var destination: Destination.State?
        
        @Presents
        public var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case onExperiencesLoaded([Experience])
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case onCreateExperienceTap
        case onSelectExperiencesTap
        case onEditExperienceTap(Experience)
        case onDeleteExperienceTap(Experience)
        
        public enum Alert: Equatable{
            case confirm(Experience.ID)
        }
        
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case experienceForm(ExperienceFormFeature)
        case experiencePicker(iOSExperiencesFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .onTask:
                return .run {[client] send in
                    do {
                        let experiences = try await client.fetch()
                        await send(.onExperiencesLoaded(experiences))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .onExperiencesLoaded(let experiences):
                state.experiences = experiences
                return .none
            case .onCreateExperienceTap:
                state.destination = .experienceForm(.init(experience: .init(id: UUID().uuidString), mode: .create))
                return .none
            case .onSelectExperiencesTap:
                let alreadySelectedExperiencesIds = state.experiences.map(\.id)
                state.destination = .experiencePicker(
                    .init(
                        mode: .picker,
                        selectedExperiencesIDs: .init(alreadySelectedExperiencesIds)
                    )
                )
                return .none
            case .onEditExperienceTap(let experience):
                state.destination = .experienceForm(.init(experience: experience, mode: .edit))
                return .none
            case .onDeleteExperienceTap(let experience):
                state.alert = AlertState {
                    TextState("Remove Experience?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .confirm(experience.id)
                    ) {
                        TextState("Remove")
                    }

                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(
                        "Are you sure you want to remove \"\(experience.role)\" from your portfolio? The experience and its data will not be deleted and can be added back later."
                    )
                }
                return .none
            case .destination(.presented(.experienceForm(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(.presented(.experienceForm(.delegate(.update(let experience))))):
                if let index = state.experiences.firstIndex(where: { $0.id == experience.id }){
                    state.experiences[index] = experience
                }else {
                    state.experiences.append(experience)
                }
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .binding(_):
                return .none
            case .alert(.presented(.confirm(let experienceId))):
                state.alert = nil
                state.experiences.removeAll { $0.id == experienceId }
                return .none
            case .alert(.dismiss):
                state.alert = nil
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ExperiencesFeature.Destination.State: Equatable {}
