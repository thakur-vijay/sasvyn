//
//  RealtimeClient.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import ComposableArchitecture

public protocol RealtimeClientProtocol: Sendable {
    var state: RealtimeConnectionState { get }
    func messages() -> AsyncStream<RealtimeMessage>

    func connect() async throws
    func disconnect()
    func send(_ message: RealtimeMessage) async throws
}

public struct RealtimeClient: Sendable {
    public var state: @Sendable () -> RealtimeConnectionState
    public var messages: @Sendable () -> AsyncStream<RealtimeMessage>
    
    public var connect: @Sendable () async throws -> Void
    public var disconnect: @Sendable () -> Void
    public var send: @Sendable (_ message: RealtimeMessage) async throws -> Void
}

extension RealtimeClient: DependencyKey {
    
    public static let liveValue: RealtimeClient = Self(
        state: {
            fatalError("RealtimeClient has not been registered")
        },
        messages: {
            fatalError("RealtimeClient has not been registered")
        },
        connect: {
            fatalError("RealtimeClient has not been registered")
        },
        disconnect: {
            fatalError("RealtimeClient has not been registered")
        },
        send: { _ in
            fatalError("RealtimeClient has not been registered")
        }
    )
    
    public static func live(
        client: any RealtimeClientProtocol
    ) -> Self {
        Self(
            state: {
                client.state
            },
            messages: {
                client.messages()
            },
            connect: {
                try await client.connect()
            },
            disconnect: {
                client.disconnect()
            },
            send: { message in
                try await client.send(message)
            }
        )
    }
}

public extension DependencyValues {

    var realtimeClient: RealtimeClient {
        get { self[RealtimeClient.self] }
        set { self[RealtimeClient.self] = newValue }
    }
}

