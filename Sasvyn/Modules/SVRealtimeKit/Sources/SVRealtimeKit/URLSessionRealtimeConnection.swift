//
//  URLSessionRealtimeConnection.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation
import NetworkKit
import SVNetwork

public final class URLSessionRealtimeConnection: RealtimeConnection, @unchecked Sendable {

    // MARK: - State

    public private(set) var state: RealtimeConnectionState = .disconnected

    // MARK: - Dependencies

    private let configuration: RealtimeConfiguration
    private let authManager: AuthManager
    private let cliendIDStore: any ClientIDStoring

    private let delegate: WebSocketSessionDelegate
    private let session: URLSession

    // MARK: - WebSocket

    private var task: URLSessionWebSocketTask?
    private var receiveTask: Task<Void, Never>?

    // MARK: - Connection

    private var connectionContinuation:
        CheckedContinuation<Void, Error>?

    private var isDisconnecting = false

    // MARK: - Subscribers

    private let subscribers = RealtimeSubscribers()

    // MARK: - Init

    public init(
        configuration: RealtimeConfiguration,
        authManager: AuthManager,
        cliendIDStore: any ClientIDStoring,
        session: URLSession? = nil
    ) {
        self.configuration = configuration
        self.authManager = authManager
        self.cliendIDStore = cliendIDStore

        let delegate = WebSocketSessionDelegate()
        self.delegate = delegate

        if let session {
            self.session = session
        } else {
            self.session = URLSession(
                configuration: .default,
                delegate: delegate,
                delegateQueue: nil
            )
        }

        delegate.onOpen = { [weak self] webSocketTask in
            self?.handleWebSocketOpened(webSocketTask)
        }

        delegate.onComplete = { [weak self] webSocketTask, error in
            self?.handleWebSocketCompleted(
                webSocketTask,
                error: error
            )
        }
    }

    deinit {
        receiveTask?.cancel()

        task?.cancel(
            with: .normalClosure,
            reason: nil
        )

        session.finishTasksAndInvalidate()
    }

    // MARK: - Messages

    public func messages() -> AsyncStream<RealtimeMessage> {
        let id = UUID()

        return AsyncStream { continuation in

            Task {
                await subscribers.add(
                    id: id,
                    continuation: continuation
                )
            }

            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.subscribers.remove(id: id)
                }
            }
        }
    }

    // MARK: - Connect

    public func connect() async throws {

        guard state == .disconnected else {
            return
        }

        isDisconnecting = false
        state = .connecting

        print("[Realtime] Connecting")

        do {

            try await establishConnection()

            print("[Realtime] WebSocket connected")

        } catch {

            print(
                "[Realtime] WebSocket connection failed: \(error)"
            )

            guard !isDisconnecting else {
                state = .disconnected
                throw CancellationError()
            }

            // ---------------------------------------------
            // Token refresh + one retry
            // ---------------------------------------------

            print("[Realtime] Refreshing access token")

            do {

                _ = try await authManager.refreshTokenIfNeeded()

                print("[Realtime] Access token refreshed")

                guard !isDisconnecting else {
                    state = .disconnected
                    throw CancellationError()
                }

                state = .connecting

                try await establishConnection()

                print(
                    "[Realtime] WebSocket connected after token refresh"
                )

            } catch {

                print(
                    "[Realtime] WebSocket reconnect failed: \(error)"
                )

                state = .disconnected

                throw error
            }
        }
    }

    // MARK: - Establish Connection

    private func establishConnection() async throws {

        receiveTask?.cancel()
        receiveTask = nil

        task?.cancel(
            with: .goingAway,
            reason: nil
        )

        task = nil

        guard !isDisconnecting else {
            throw CancellationError()
        }

        print("[Realtime] Creating WebSocket task")

        var request = URLRequest(
            url: configuration.url
        )

        // ---------------------------------------------
        // Read token ONLY from AuthManager
        // ---------------------------------------------

        if let token = await authManager.accessToken {

            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )

            print("[Realtime] Authorization header added")

        } else {

            print("[Realtime] No access token available")
        }
        
        if let clientID = cliendIDStore.clientID {

            request.setValue(
                clientID,
                forHTTPHeaderField: "X-Client-ID"
            )

            print("[Realtime] X-Client-ID header added")

        } else {

            print("[Realtime] No X-Client-ID available")
        }

        let webSocketTask = session.webSocketTask(
            with: request
        )

        task = webSocketTask

        print("[Realtime] WebSocket task created")

        try await withCheckedThrowingContinuation {
            (
                continuation: CheckedContinuation<Void, Error>
            ) in

            connectionContinuation = continuation

            webSocketTask.resume()

            print("[Realtime] WebSocket task resumed")
        }

        guard task === webSocketTask else {
            throw URLError(.cancelled)
        }

        guard !isDisconnecting else {
            throw CancellationError()
        }

        // ---------------------------------------------
        // Actual handshake completed
        // ---------------------------------------------

        state = .connected

        print("[Realtime] WebSocket state = connected")

        receiveTask?.cancel()

        receiveTask = Task { [weak self, weak webSocketTask] in

            guard let self else {
                return
            }

            guard let webSocketTask else {
                return
            }

            await self.receiveLoop(
                webSocketTask
            )
        }
    }

    // MARK: - Disconnect

    public func disconnect() {

        print("[Realtime] Disconnecting")

        isDisconnecting = true

        receiveTask?.cancel()
        receiveTask = nil

        task?.cancel(
            with: .normalClosure,
            reason: nil
        )

        task = nil

        state = .disconnected

        // Release connect() if it is waiting
        // for the WebSocket handshake.

        if let continuation = connectionContinuation {

            connectionContinuation = nil

            continuation.resume(
                throwing: CancellationError()
            )
        }
    }

    // MARK: - Send

    public func send(
        _ message: RealtimeMessage
    ) async throws {

        guard state == .connected else {
            throw RealtimeError.notConnected
        }

        guard let task else {
            throw RealtimeError.notConnected
        }

        let data = try JSONEncoder().encode(
            message
        )

        try await task.send(
            .data(data)
        )
    }

    // MARK: - WebSocket Opened

    private func handleWebSocketOpened(
        _ webSocketTask: URLSessionWebSocketTask
    ) {

        guard task === webSocketTask else {
            return
        }

        guard !isDisconnecting else {
            return
        }

        print(
            "[Realtime] WebSocket didOpenWithProtocol"
        )

        guard let continuation = connectionContinuation else {
            return
        }

        connectionContinuation = nil

        continuation.resume()
    }

    // MARK: - WebSocket Completed

    private func handleWebSocketCompleted(
        _ webSocketTask: URLSessionWebSocketTask,
        error: Error?
    ) {

        guard task === webSocketTask else {
            return
        }

        print(
            "[Realtime] WebSocket didCompleteWithError: \(String(describing: error))"
        )

        // ---------------------------------------------
        // Handshake never completed
        // ---------------------------------------------

        if let continuation = connectionContinuation {

            connectionContinuation = nil

            if let error {

                continuation.resume(
                    throwing: error
                )

            } else {

                continuation.resume(
                    throwing: URLError(
                        .networkConnectionLost
                    )
                )
            }

            return
        }

        // ---------------------------------------------
        // Already connected, then disconnected
        // ---------------------------------------------

        guard !isDisconnecting else {
            return
        }

        state = .disconnected

        task = nil

        receiveTask?.cancel()
        receiveTask = nil
    }

    // MARK: - Receive Loop

    private func receiveLoop(
        _ webSocketTask: URLSessionWebSocketTask
    ) async {

        print("[Realtime] Receive loop started")

        do {

            while !Task.isCancelled {

                let message = try await webSocketTask.receive()

                guard !Task.isCancelled else {
                    return
                }

                switch message {

                case .data(let data):

                    let realtimeMessage =
                        try JSONDecoder().decode(
                            RealtimeMessage.self,
                            from: data
                        )

                    await subscribers.yield(
                        realtimeMessage
                    )

                case .string(let string):

                    guard let data = string.data(
                        using: .utf8
                    ) else {
                        continue
                    }

                    let realtimeMessage =
                        try JSONDecoder().decode(
                            RealtimeMessage.self,
                            from: data
                        )

                    await subscribers.yield(
                        realtimeMessage
                    )

                @unknown default:
                    break
                }
            }

        } catch {

            guard !Task.isCancelled else {
                return
            }

            print(
                "[Realtime] Receive loop failed: \(error)"
            )

            guard task === webSocketTask else {
                return
            }

            task = nil
            state = .disconnected
        }
    }
}

// MARK: - WebSocket Session Delegate

private final class WebSocketSessionDelegate:
    NSObject,
    URLSessionWebSocketDelegate,
    URLSessionTaskDelegate
{

    var onOpen:
        ((URLSessionWebSocketTask) -> Void)?

    var onComplete:
        ((URLSessionWebSocketTask, Error?) -> Void)?

    // MARK: Open

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {

        print(
            "[Realtime] Delegate: didOpenWithProtocol"
        )

        onOpen?(webSocketTask)
    }

    // MARK: Complete

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {

        guard let webSocketTask =
            task as? URLSessionWebSocketTask
        else {
            return
        }

        print(
            "[Realtime] Delegate: didCompleteWithError"
        )

        onComplete?(
            webSocketTask,
            error
        )
    }
}
