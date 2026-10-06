//
//  RealtimeConnection.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public protocol RealtimeConnection: Sendable {
    var state: RealtimeConnectionState { get }

    func connect() async throws
    func disconnect()
    func send(_ message: RealtimeMessage) async throws
    
    func messages() -> AsyncStream<RealtimeMessage>
}
