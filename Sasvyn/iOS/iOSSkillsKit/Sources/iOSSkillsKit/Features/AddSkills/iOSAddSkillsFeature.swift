//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture

@Reducer
public struct iOSAddSkillsFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var skillNames: [String] = []
        public var skills: [SkillModel] = []
        public var skillName: String = ""
        public var skillNameScrollPosition: String?
        public var skillCategory: SkillCategory = .languages
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case closeTapped
        case addSkillTapped
        case addSkillsTapped
        case categorySelected
        case addAllSkillsTapped
        case deleteSkillNameTapped(String)
        case deleteSkillTapped(SkillModel)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case addSkills
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return .send(.delegate(.close))
            case .addSkillTapped:
                state.skillNames.append(state.skillName)
                state.skillNameScrollPosition = state.skillNames.last
                return .none
            case .addSkillsTapped:
                let newSkills = state.skillNames.map { SkillModel(skill: $0, category: state.skillCategory)}
                state.skills.append(contentsOf: newSkills)
                return .none
            case .categorySelected:
                return .none
            case .addAllSkillsTapped:
                return .send(.delegate(.addSkills))
            case .deleteSkillNameTapped(let skillName):
                state.skillNames.removeAll { $0.isEqual(skillName)}
                return .none
            case .deleteSkillTapped(let skill):
                state.skills.removeAll { $0.id == skill.id}
                return .none
            case .delegate(_):
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
