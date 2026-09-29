//
//  SyncStatus.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 29/09/26.
//


import Foundation

public enum SyncStatus: String, Codable, Hashable, Sendable {
    case pending
    case syncing
    case synced
    case failed
    case idle
}
