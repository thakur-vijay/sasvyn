//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public protocol DocumentsRepository: Sendable {
    
    func fetch(category: DocumentCategory?)async throws -> [Document]
    func add(document: Document) async throws
    func delete(id: String) async throws
}
