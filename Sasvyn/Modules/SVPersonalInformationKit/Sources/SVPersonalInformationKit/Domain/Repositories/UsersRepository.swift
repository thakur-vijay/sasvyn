//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol UsersRepository: Sendable {
    func fetchCurrentUser() -> AsyncStream<User>
    func update(_ user: User) async throws
    func updateImage(_ user: User) async throws
}
