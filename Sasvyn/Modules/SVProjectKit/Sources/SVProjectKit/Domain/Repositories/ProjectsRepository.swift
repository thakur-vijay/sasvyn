//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol ProjectsRepository: Sendable {
    
    func fetch(search: String)async throws -> [Project]
    func add(project: Project) async throws
    func update(project: Project) async throws
    func delete(id: String) async throws
    func fetch(id: String) async throws->Project?
    func removeSkill(id: String, from projectID: String) async throws
    func deleteProjectScreenshots(screenshots: [ProjectScreenshot]) async throws
    func addProjectScreenshots(screenshots: [ProjectScreenshot], projectID: String) async throws
    func reorderProjectScreenshots(screenshots: [ProjectScreenshot]) async throws
}
