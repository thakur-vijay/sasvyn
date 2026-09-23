//
//  SyncSleeper.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncSleeper: Sendable {
    func sleep(
        for duration: TimeInterval
    ) async throws
}

public struct DefaultSyncSleeper: SyncSleeper {

    public init() {}

    public func sleep(
        for duration: TimeInterval
    ) async throws {
        try await Task.sleep(
            nanoseconds: UInt64(max(0, duration) * 1_000_000_000)
        )
    }
}
