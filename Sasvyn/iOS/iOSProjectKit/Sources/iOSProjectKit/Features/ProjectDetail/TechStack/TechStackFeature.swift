//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture
import iOSSkillsKit
import SVSkillsKit
import SVProjectKit

@Reducer
public struct TechStackFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var techStack: [Skill] = []
        public var mode: ProjectMode
        public init(mode: ProjectMode){
            self.mode = mode
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case destination(PresentationAction<Destination.Action>)
        case addStackTapped
        case setData(_ techStack: [Skill])
        case deleteStackTapped(Skill)
        case delegate(Delegate)
        
        public enum Delegate {
            case updateStack
        }
    }
    
    @Reducer
    public enum Destination {
        case skillsPicker(iOSSkillsPickerFeature)
    }
    
    public init(){}
    

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            case .binding(_):
                return .none
            case .addStackTapped:
                let alreadySelectedIDs = Set(state.techStack.map { $0.id })
                state.destination = .skillsPicker(.init(selectedSkillIDs: alreadySelectedIDs))
                return .none
            case .destination(.presented(.skillsPicker(.delegate(.cancelTapped)))):
                state.destination = nil
                return .none
            case .destination(.presented(.skillsPicker(.delegate(.saveTapped(let skills))))):
                state.techStack = skills
                state.destination = nil
                return .send(.delegate(.updateStack))
            case .destination(_):
                return .none
            case .setData(let techStack):
                state.techStack = techStack
                return .none
            case .deleteStackTapped(let skill):
                state.techStack.removeAll { $0.id == skill.id }
                return .send(.delegate(.updateStack))
            case .delegate(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

internal extension TechStackFeature.State {
    var isDetailsReady: Bool {
        !techStack.isEmpty
    }
    
    func update(into project: inout Project) {
        project.techStack = techStack
    }
}

extension TechStackFeature.Destination.State: Equatable {}
