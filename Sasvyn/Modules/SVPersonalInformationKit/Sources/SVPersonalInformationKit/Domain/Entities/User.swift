//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSyncKit

public struct User: Identifiable, Hashable, Codable, Sendable, SyncableEntity {
    public let id: String
    public let appleId: String
    public var fullName: String
    public var email: String
    public var dateOfBirth: Date?
    public var imageLocalUrl: URL?
    public var imageUrl: String?
    public var serverVersion: Int64
    public var updatedAt: Date

    public var syncVersion: Int64 {
        serverVersion
    }
    
    public init(
        id: String,
        appleId: String,
        fullName: String,
        email: String,
        dateOfBirth: Date? = nil,
        imageLocalUrl: URL? = nil,
        imageUrl: String? = nil,
        serverVersion: Int64 = 0,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.appleId = appleId
        self.fullName = fullName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.imageLocalUrl = imageLocalUrl
        self.imageUrl = imageUrl
        self.serverVersion = serverVersion
        self.updatedAt = updatedAt
    }
    
}
