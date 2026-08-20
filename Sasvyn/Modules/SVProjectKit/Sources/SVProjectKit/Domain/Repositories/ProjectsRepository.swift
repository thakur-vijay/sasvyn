//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol ProjectsRepository: Sendable {
    
    func fetch()async throws -> [Project]
    func add(project: Project) async throws
    func update(project: Project) async throws
    func delete(id: String) async throws
}
