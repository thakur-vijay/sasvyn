//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol SkillsRepository: Sendable {
    
    func fetch()-> AsyncStream<[SkillMainModel]>
    func add(skill: Skill) async throws
    func update(skill: Skill) async throws
    func delete(id: String) async throws
}
