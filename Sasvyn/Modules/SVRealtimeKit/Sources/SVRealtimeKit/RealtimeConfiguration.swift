//
//  RealtimeConfiguration.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public struct RealtimeConfiguration: Sendable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }
}
