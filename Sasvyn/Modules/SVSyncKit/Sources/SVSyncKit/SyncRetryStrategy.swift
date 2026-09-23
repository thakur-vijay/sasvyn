//
//  SyncRetryStrategy.swift
//  SVSyncKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public protocol SyncRetryStrategy: Sendable {

    func decision(
        for error: Error
    ) -> SyncRetryDecision
}

public struct DefaultSyncRetryStrategy: SyncRetryStrategy {

    public init() {}

    public func decision(
        for error: Error
    ) -> SyncRetryDecision {

        if error is CancellationError {
            return .doNotRetry
        }

        switch error {
           case SyncError.entityNotFound,
               SyncError.remoteEntityMissing,
             SyncError.conflict,
             SyncError.invalidState,
             SyncError.cancelled,
             SyncError.retryLimitExceeded:
            return .doNotRetry

        default:
            return error is any SyncRetryableError ? .retry : .doNotRetry
        }
    }
}

public protocol SyncRetryableError: Error, Sendable {
    var isRetryable: Bool { get }
}
