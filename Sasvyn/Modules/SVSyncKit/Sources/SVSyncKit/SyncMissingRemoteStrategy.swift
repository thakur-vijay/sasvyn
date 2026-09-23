//
//  SyncMissingRemoteStrategy.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncMissingRemoteStrategy: Sendable {
    case uploadLocal
    case deleteLocal
    case fail
}
