//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation

internal struct SkillReponseDTO: Codable, Hashable, Sendable{
    let id: String
    let userId: String
    let skill: String
    let category: String
    let syncVersion: Int64
    let createdAt: Date
    let updatedAt: Date

}

internal extension SkillReponseDTO {
    func toDomain()-> Skill {
        .init(
            id: id,
            skill: skill,
            category: SkillCategory(rawValue: category) ?? .languages,
            syncVersion: syncVersion,
            updatedAt: updatedAt
        )
    }
}
