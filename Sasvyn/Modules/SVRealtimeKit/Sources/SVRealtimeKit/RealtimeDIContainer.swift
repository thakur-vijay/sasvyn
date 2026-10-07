//
//  File.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation
import ComposableArchitecture
import NetworkKit
import SVNetwork

public final class RealtimeDIContainer {
    private let url: URL
    private let authManager: AuthManager
    private let clientIDStore: any ClientIDStoring
    
    public init(
        url: URL,
        authManager: AuthManager,
        clientIDStore: any ClientIDStoring
    ) {
        self.url = url
        self.authManager = authManager
        self.clientIDStore = clientIDStore
    }
    
    private lazy var client: any RealtimeClientProtocol = {
        DefaultRealtimeClient(connection: connection)
    }()
    
    private lazy var connection: any RealtimeConnection = {
        URLSessionRealtimeConnection(
            configuration: configuration,
            authManager: authManager,
            cliendIDStore: clientIDStore
        )
    }()
    
    private lazy var configuration: RealtimeConfiguration = {
        .init(url: url)
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.realtimeClient = .live(client: client)
    }
    
    
}
