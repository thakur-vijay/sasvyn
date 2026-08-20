//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct Skill: Identifiable, Hashable, Sendable{
    public let id: String
    public let skill: String
    public let category: SkillCategory
    
    public init(id: String, skill: String, category: SkillCategory) {
        self.id = id
        self.skill = skill
        self.category = category
    }
}
