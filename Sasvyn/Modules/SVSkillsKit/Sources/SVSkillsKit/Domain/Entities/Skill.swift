//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSyncKit

public struct Skill: Identifiable, Hashable, Sendable, SyncableEntity{
    public static let entityType: SVSyncKit.SyncEntityType = .skill

    public let id: String
    public let skill: String
    public let category: SkillCategory
    
    public let syncVersion: Int64
    
    public let updatedAt: Date
    
    
    public init(
        id: String,
        skill: String,
        category: SkillCategory,
        syncVersion: Int64,
        updatedAt: Date
    ) {
        self.id = id
        self.skill = skill
        self.category = category
        self.syncVersion = syncVersion
        self.updatedAt = updatedAt
    }
}
