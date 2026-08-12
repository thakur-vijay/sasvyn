//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import Foundation

public struct SkillModel: Identifiable, Hashable{
    public var id: String = UUID().uuidString
    public var skill: String
    public var category: SkillCategory
    
    public init(skill: String, category: SkillCategory) {
        self.skill = skill
        self.category = category
    }
}
