//
//  SyncRetryPolicy.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct SyncRetryPolicy: Sendable {

    public let maxRetries: Int
    public let baseDelay: TimeInterval
    public let maxDelay: TimeInterval
    public let jitterFactor: Double

    public init(
        maxRetries: Int = 5,
        baseDelay: TimeInterval = 1,
        maxDelay: TimeInterval = 60,
        jitterFactor: Double = 0.2
    ) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.jitterFactor = jitterFactor
    }

    public func shouldRetry(
        retryCount: Int
    ) -> Bool {
        retryCount < maxRetries
    }

    public func delay(
        retryCount: Int
    ) -> TimeInterval {
        let exponentialDelay =
            baseDelay * pow(2, Double(retryCount))

        let cappedDelay = min(
            exponentialDelay,
            maxDelay
        )

        let jitterRange =
            cappedDelay * jitterFactor

        let jitter = Double.random(
            in: -jitterRange...jitterRange
        )

        return max(
            0,
            cappedDelay + jitter
        )
    }
}
