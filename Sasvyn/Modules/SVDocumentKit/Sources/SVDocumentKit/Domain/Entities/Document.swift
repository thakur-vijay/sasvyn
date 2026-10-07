//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSyncKit

public struct Document: Identifiable, Hashable, Sendable, SyncableEntity{
    public static let entityType: SVSyncKit.SyncEntityType = .document
    public let id: String
    public let localUrl: URL?
    public let url: URL?
    public let name: String
    public let createdAt: Date
    public let fileSize: Int64
    public let category: DocumentCategory
    public let syncVersion: Int64
    public let updatedAt: Date
    
    public init(
        id: String,
        localUrl: URL?,
        url: URL?,
        name: String,
        createdAt: Date,
        fileSize: Int64,
        category: DocumentCategory,
        syncVersion: Int64,
        updatedAt: Date,
    ) {
        self.id = id
        self.localUrl = localUrl
        self.url = url
        self.name = name
        self.createdAt = createdAt
        self.fileSize = fileSize
        self.category = category
        self.syncVersion = syncVersion
        self.updatedAt = updatedAt
    }
}
