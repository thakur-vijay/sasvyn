//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSkillsKit

public struct Project: Identifiable, Hashable, Sendable{
    public let id: String
    public var icon: URL?
    public var name: String
    public var category: AppCategory?
    public var tagline: String
    public var overview: String
    public var role: String
    public var techStack: [Skill]
    public var screenshots: [ProjectScreenshot]
    
    public init(
        id: String = UUID().uuidString,
        icon: URL? = nil,
        name: String = "",
        category: AppCategory? = nil,
        tagline: String = "",
        overview: String = "",
        role: String = "",
        techStack: [Skill] = [],
        screenshots: [ProjectScreenshot] = [],
    ) {
        self.id = id
        self.icon = icon
        self.name = name
        self.category = category
        self.tagline = tagline
        self.overview = overview
        self.role = role
        self.techStack = techStack
        self.screenshots = screenshots
    }
    
}
