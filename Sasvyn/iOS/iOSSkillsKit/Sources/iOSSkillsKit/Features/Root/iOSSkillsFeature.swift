//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVSkillsKit

@Reducer
public struct iOSSkillsFeature {
    
    @Dependency(\.skillsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var skillGroups: [SkillMainModel] = []
        @Presents
        public var destination: Destination.State?
        public init(){
            
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case onTask
        case skillsLoaded([SkillMainModel])
        case skillsUpdated
        case addSkillsTapped
        case deleteSkillTapped(_ groupIndex: Int, _ skill: Skill)
        case deleteSkillSucceeded(_ groupIndex: Int, _ skill: Skill)
        case deleteSkillFailed
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case addSkills(iOSAddSkillsFeature)
    }
    
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run {[client] send in
                    let groups = try await client.fetch()
                    await send(.skillsLoaded(groups))
                }
            case .addSkillsTapped:
                state.destination = .addSkills(iOSAddSkillsFeature.State())
                return .none
            case .binding(_):
                return .none
            case .destination(.presented(.addSkills(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(.presented(.addSkills(.delegate(.skillsAdded(let category, let skills))))):
                if let index = state.skillGroups.firstIndex(where: { $0.category == category }){
                    state.skillGroups[index].skills.append(contentsOf: skills)
                }else {
                    let newGroup = SkillMainModel(category: category, skills: skills)
                    state.skillGroups.append(newGroup)
                }
                return .send(.skillsUpdated)
            case .destination(.presented(.addSkills(.delegate(.skillDeleted(let skill))))):
                if let index = state.skillGroups.firstIndex(where: { $0.category == skill.category }){
                    state.skillGroups[index].skills.removeAll { $0.id == skill.id }
                    if state.skillGroups[index].skills.isEmpty {
                        state.skillGroups.remove(at: index)
                    }
                }
                return .send(.skillsUpdated)
            case .destination(_):
                return .none
            case .skillsLoaded(let groups):
                state.skillGroups = groups
                return .none
            case .deleteSkillTapped(let groupIndex, let skill):
                return .run {[client] send in
                    do {
                        try await client.delete(skill.id)
                        await send(.deleteSkillSucceeded(groupIndex, skill))
                    }catch {
                        await send(.deleteSkillFailed)
                    }
                }
            case .deleteSkillSucceeded(let groupIndex, let skill):
                state.skillGroups[groupIndex].skills.removeAll { $0.id == skill.id}
                if state.skillGroups[groupIndex].skills.isEmpty {
                    state.skillGroups.remove(at: groupIndex)
                }
                return .send(.skillsUpdated)
            case .deleteSkillFailed:
                return .none
            case .skillsUpdated:
                state.skillGroups = state.skillGroups.sorted { $0.category.order < $1.category.order }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSSkillsFeature.Destination.State: Equatable {}
