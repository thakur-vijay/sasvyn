//
//  DefaultRealtimeClient.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public final class DefaultRealtimeClient: RealtimeClientProtocol, @unchecked Sendable {

    private let connection: RealtimeConnection

    public init(connection: RealtimeConnection) {
        self.connection = connection
    }

    public var state: RealtimeConnectionState {
        connection.state
    }

    public func messages() -> AsyncStream<RealtimeMessage> {
        connection.messages()
    }

    public func connect() async throws {
        try await connection.connect()
    }

    public func disconnect() {
        connection.disconnect()
    }

    public func send(_ message: RealtimeMessage) async throws {
        try await connection.send(message)
    }
}
