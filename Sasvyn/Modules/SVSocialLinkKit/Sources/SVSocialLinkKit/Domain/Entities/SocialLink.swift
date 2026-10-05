//
//  SocialLink.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//


import Foundation
import SVSyncKit

public struct SocialLink: Identifiable, Hashable, Codable, Sendable, SyncableEntity{
    public static let entityType: SVSyncKit.SyncEntityType = .socialLink
    
    public let id: String
    public var type: LinkType?
    public var url: URL?
    public let syncVersion: Int64
    public let updatedAt: Date

    public init(
        id: String,
        type: LinkType? = nil,
        url: URL? = nil,
        syncVersion: Int64,
        updatedAt: Date
    ) {
        self.id = id
        self.type = type
        self.url = url
        self.syncVersion = syncVersion
        self.updatedAt = updatedAt
    }
}
