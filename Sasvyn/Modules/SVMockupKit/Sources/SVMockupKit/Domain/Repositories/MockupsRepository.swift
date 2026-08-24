//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol MockupsRepository: Sendable {
    
    func fetch()async throws -> [MockupModel]
    func add(mockup: MockupModel) async throws
    func delete(id: String) async throws
}
