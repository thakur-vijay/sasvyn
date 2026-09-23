//
//  SyncState.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncState: Sendable, Equatable {
    case idle
    case pending
    case synced(version: Int64)
    case syncing
    case failed(message: String)
}
