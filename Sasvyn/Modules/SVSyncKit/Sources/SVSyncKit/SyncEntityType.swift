//
//  SyncEntityType.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 30/09/26.
//

import Foundation

public enum SyncEntityType: String, Sendable, Codable {
    case user
    case socialLink = "social_link"
    case skill
    case language
    case project
}
