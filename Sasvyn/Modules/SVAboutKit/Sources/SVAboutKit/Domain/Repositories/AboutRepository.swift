//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol AboutRepository: Sendable {
    func fetch(_ userId: String) async throws -> About
    func save(_ about: About)async throws
}
