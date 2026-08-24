//
//  File.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation

public struct MockupModel: Identifiable, Hashable, Sendable {
    public let id: String
    public let url: URL?
    public let thumbnail: URL?
    public let size: Int64
    public let aspectRatio: Double
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        url: URL?,
        thumbnail: URL?,
        size: Int64,
        aspectRatio: Double,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.url = url
        self.thumbnail = thumbnail
        self.size = size
        self.aspectRatio = aspectRatio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
