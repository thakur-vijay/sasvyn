//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct Document: Identifiable, Hashable, Sendable{
    public let id: String
    public let url: URL
    public let name: String
    public let createdAt: Date
    public let fileSize: Int64
    public let category: DocumentCategory
    
    public init(id: String, url: URL, name: String, createdAt: Date, fileSize: Int64, category: DocumentCategory) {
        self.id = id
        self.url = url
        self.name = name
        self.createdAt = createdAt
        self.fileSize = fileSize
        self.category = category
    }
}
