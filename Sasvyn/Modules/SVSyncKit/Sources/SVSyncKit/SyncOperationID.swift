//
//  SyncOperationID.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation
import SVFoundation

public struct SyncOperationID: Hashable, Sendable, Codable {

    public let value: String

    public init(
        value: String = IDGenerator.uuid()
    ) {
        self.value = value
    }
}
