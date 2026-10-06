//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVSkillsKit
import Foundation
import SVSpotlightKit
import SVFoundation

@Reducer
public struct iOSAddSkillsFeature {
    
    @Dependency(\.skillsClient)
    private var client
    
    @Dependency(\.spotlightClient)
    private var spotlightClient
    
    @ObservableState
    public struct State: Equatable {
        public var skills: [Skill] = []
        public var skillName: String = ""
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
        case categorySelected
        case skillAdded(Skill)
        case skillFailedToAdd
        case deleteSkillTapped(Skill)
        case skillDeleted(Skill)
        case skillFailedToDelete
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case skillAdded(Skill)
            case skillDeleted(Skill)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .onTask:
                return .run { send in
                    
                }
            case .closeTapped:
                return .send(.delegate(.close))
            case .addSkillTapped:
                let category = state.skillCategory ?? .languages
                let skillName = state.skillName
                let skill = Skill(
                    id: IDGenerator.uuid(),
                    skill: skillName,
                    category: category,
                    syncVersion: 1,
                    updatedAt: .now
                )
                let spotlightItem =  SVSpotlightItem(
                    destination: .skill(id: skill.id),
                    title: skill.skill,
                    description: category.title,
                    keywords: [skill.skill, category.rawValue],
                    domainIdentifier: "skills"
                )
                return .run {[client, spotlightClient] send in
                    do {
                        try await client.add(skill)
                        try await spotlightClient.index(spotlightItem)
                        await send(.skillAdded(skill))
                    }catch {
                        await send(.skillFailedToAdd)
                    }
                }
            case .categorySelected:
                return .none
            case .deleteSkillTapped(let skill):
                return .run { [client, spotlightClient] send in
                    do {
                        try await client.delete(skill.id)
                        try await spotlightClient.delete(skill.id)
                        await send(.skillDeleted(skill))
                    }catch {
                        await send(.skillFailedToDelete)
                    }
                }
            case .delegate(_):
                return .none
            case .binding(_):
                return .none
            case .skillAdded(let skill):
                state.skillName.removeAll()
                state.skills.append(skill)
                return .send(.delegate(.skillAdded(skill)))
            case .skillFailedToAdd:
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
