//
//  SkillMainModel.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct SkillMainModel: Sendable, Equatable{
    public var category: SkillCategory
    public var skills: [Skill]
    
    public init(category: SkillCategory, skills: [Skill]) {
        self.category = category
        self.skills = skills
    }
}
