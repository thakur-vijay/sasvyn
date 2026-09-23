//
//  SyncOperationID.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncOperationID: Hashable, Sendable, Codable {

    public let value: String

    public init(
        value: String = UUID().uuidString
    ) {
        self.value = value
    }
}
