//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import ComposableArchitecture
import SVSkillsKit

@Reducer
public struct iOSSkillsPickerFeature {
    
    @Dependency(\.skillsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        var skillGroups: [SkillMainModel] = []
        var selectedSkillIDs: Set<String>

        var selectedSkills: [Skill] {
            skillGroups
                .flatMap(\.skills)
                .filter { selectedSkillIDs.contains($0.id) }
        }

        public init(selectedSkillIDs: Set<String>) {
            self.selectedSkillIDs = selectedSkillIDs
        }
    }
    
    public enum Action{
        case onTask
        case skillsLoaded([SkillMainModel])
        case skillTapped(Skill)
        case saveTapped
        case cancelTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case saveTapped([Skill])
            case cancelTapped
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run {[client] send in
                    let groups = try await client.fetch()
                    await send(.skillsLoaded(groups))
                }
            case .skillsLoaded(let groups):
                state.skillGroups = groups
                return .none
            case .skillTapped(let skill):
                if state.selectedSkillIDs.contains(skill.id) {
                    state.selectedSkillIDs.remove(skill.id)
                } else {
                    state.selectedSkillIDs.insert(skill.id)
                }

                return .none
            case .saveTapped:
                return .send(.delegate(.saveTapped(state.selectedSkills)))
            case .cancelTapped:
                return .send(.delegate(.cancelTapped))
            case .delegate(_):
                return .none
            }
        }
    }
}
