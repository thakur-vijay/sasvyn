//
//  SVColumnName.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import Foundation

public struct SVColumnName: Sendable, Hashable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
