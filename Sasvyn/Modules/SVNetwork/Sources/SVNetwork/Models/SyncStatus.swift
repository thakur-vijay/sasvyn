//
//  SyncStatus.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncStatus: String, Codable, Hashable, Sendable {
    case pending
    case syncing
    case synced
    case failed
}
