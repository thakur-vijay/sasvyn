//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol SkillsRepository: Sendable {
    
    func fetch()async throws -> [SkillMainModel]
    func add(skills: [Skill]) async throws
    func delete(id: String) async throws
}
