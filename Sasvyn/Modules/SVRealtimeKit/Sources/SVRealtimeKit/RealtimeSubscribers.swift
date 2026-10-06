//
//  RealtimeSubscribers.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

actor RealtimeSubscribers {
    private var subscribers: [
        UUID: AsyncStream<RealtimeMessage>.Continuation
    ] = [:]

    func add(
        id: UUID,
        continuation: AsyncStream<RealtimeMessage>.Continuation
    ) {
        subscribers[id] = continuation
    }

    func remove(id: UUID) {
        subscribers.removeValue(forKey: id)
    }

    func yield(_ message: RealtimeMessage) {
        for subscriber in subscribers.values {
            subscriber.yield(message)
        }
    }
    
    func finish() {
        for subscriber in subscribers.values {
            subscriber.finish()
        }

        subscribers.removeAll()
    }
}
