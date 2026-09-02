//
//  File.swift
//  iOSExperienceKit
//
//  Created by Vijay Thakur on 01/09/26.
//

import ComposableArchitecture
import Foundation
import SVExperienceKit

@Reducer
public struct iOSExperiencesFeature {
    @Dependency(\.experiencesClient) private var client

    @ObservableState
    public struct State: Equatable {
        public var experiences: [Experience] = []
        public var experienceToDelete: Experience?
        @Presents public var destination: Destination.State?
        @Presents public var alert: AlertState<Action.Alert>?

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case addTapped
        case editTapped(Experience)
        case deleteTapped(Experience)
        case experienceDeleted(Experience)
        case onTask
        case experiencesLoaded([Experience])

        public enum Alert { case deleteConfirmed }
    }

    public init() {}

    @Reducer
    public enum Destination {
        case experienceForm(ExperienceFormFeature)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addTapped:
                state.destination = .experienceForm(.init(experience: .init(id: UUID().uuidString), mode: .create))
                return .none
            case .editTapped(let experience):
                state.destination = .experienceForm(.init(experience: experience, mode: .edit))
                return .none
            case .deleteTapped(let experience):
                state.experienceToDelete = experience
                state.alert = AlertState {
                    TextState("Delete Experience?")
                } actions: {
                    ButtonState(role: .destructive, action: .deleteConfirmed) { TextState("Delete") }
                    ButtonState(role: .cancel) { TextState("Cancel") }
                } message: {
                    TextState("Are you sure you want to delete \"\(experience.role)\"?")
                }
                return .none
            case .alert(.presented(.deleteConfirmed)):
                guard let experience = state.experienceToDelete else { return .none }
                state.experienceToDelete = nil
                state.alert = nil
                return .run { [client] send in
                    do {
                        try await client.delete(experience.id)
                        await send(.experienceDeleted(experience), animation: .snappy)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert(.dismiss):
                state.experienceToDelete = nil
                state.alert = nil
                return .none
            case .destination(.presented(.experienceForm(.delegate(.update(let experience))))):
                if let index = state.experiences.firstIndex(where: { $0.id == experience.id }) {
                    state.experiences[index] = experience
                } else {
                    state.experiences.append(experience)
                }
                state.destination = nil
                return .none
            case .destination(.presented(.experienceForm(.delegate(.close)))):
                state.destination = nil
                return .none
            case .onTask:
                return .run { [client] send in
                    do { await send(.experiencesLoaded(try await client.fetch())) }
                    catch { print(error.localizedDescription) }
                }
            case .experiencesLoaded(let experiences):
                state.experiences = experiences
                return .none
            case .experienceDeleted(let experience):
                state.experiences.removeAll { $0.id == experience.id }
                return .none
            case .binding, .destination, .alert:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSExperiencesFeature.Destination.State: Equatable {}
