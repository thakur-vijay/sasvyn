//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVSkillsKit
import Foundation

@Reducer
public struct iOSAddSkillsFeature {
    
    @Dependency(\.skillsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var skillNames: [String] = []
        public var skills: [Skill] = []
        public var skillName: String = ""
        public var skillNameScrollPosition: String?
        public var skillCategory: SkillCategory? = .languages
        public var isSkillCategoryPickerPresented: Bool = false
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case closeTapped
        case addSkillTapped
        case addSkillsTapped
        case categorySelected
        case skillsAdded(_ category: SkillCategory, _ skills: [Skill])
        case skillsFailedToAdd
        case deleteSkillNameTapped(String)
        case deleteSkillTapped(Skill)
        case skillDeleted(Skill)
        case skillFailedToDelete
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case skillsAdded(_ category: SkillCategory, _ skills: [Skill])
            case skillDeleted(Skill)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run { send in
                    
                }
            case .closeTapped:
                return .send(.delegate(.close))
            case .addSkillTapped:
                state.skillNames.append(state.skillName)
                state.skillNameScrollPosition = state.skillNames.last
                state.skillName.removeAll()
                return .none
            case .addSkillsTapped:
                let category = state.skillCategory ?? .languages
                let newSkills = state.skillNames.map { Skill(id: UUID().uuidString, skill: $0, category: category)}
                state.skills.append(contentsOf: newSkills)
                return .run {[client] send in
                    do {
                        try await client.add(newSkills)
                        await send(.skillsAdded(category, newSkills))
                    }catch {
                        await send(.skillsFailedToAdd)
                    }
                }
            case .categorySelected:
                return .none
            case .deleteSkillNameTapped(let skillName):
                state.skillNames.removeAll { $0.isEqual(skillName)}
                return .none
            case .deleteSkillTapped(let skill):
                return .run { [client] send in
                    do {
                        try await client.delete(skill.id)
                        await send(.skillDeleted(skill))
                    }catch {
                        await send(.skillFailedToDelete)
                    }
                }
            case .delegate(_):
                return .none
            case .binding(_):
                return .none
            case .skillsAdded(let category, let skills):
                state.skillNames.removeAll()
                return .send(.delegate(.skillsAdded(category, skills)))
            case .skillsFailedToAdd:
                return .none
            case .skillDeleted(let skill):
                state.skills.removeAll { $0.id == skill.id}
                return .send(.delegate(.skillDeleted(skill)))
            case .skillFailedToDelete:
                return .none
            }
        }
    }
}
