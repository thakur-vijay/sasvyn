//
//  SyncOperation.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SyncOperation: String, Sendable, Codable, Equatable {
    case create
    case update
    case delete
}
