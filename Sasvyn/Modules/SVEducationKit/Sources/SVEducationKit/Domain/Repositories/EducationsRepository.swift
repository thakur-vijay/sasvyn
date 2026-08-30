//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol EducationsRepository: Sendable {
    
    func fetch()async throws -> [Education]
    func add(_ education: Education) async throws
    func update(_ education: Education) async throws
    func delete(_ id: String) async throws
}
