//
//  SyncRetryDecision.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncRetryDecision: Sendable {
    case retry
    case doNotRetry
}
