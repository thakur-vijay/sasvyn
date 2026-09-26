//
//  SyncError.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncError: Error, Sendable {
    case entityNotFound
    case remoteEntityMissing
    case conflict
    case uploadFailed
    case downloadFailed
    case invalidState
    case cancelled
    case retryLimitExceeded
    case pendingChangeNotFound
}
