//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public protocol SocialLinksRepository: Sendable{
    func fetch() async throws -> [SocialLink]
    func add(_ link: SocialLink) async throws
    func update(_ link: SocialLink) async throws
    func delete(_ id: String) async throws
}
