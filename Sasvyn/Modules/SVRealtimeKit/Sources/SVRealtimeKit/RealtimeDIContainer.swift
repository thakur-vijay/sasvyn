//
//  File.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation
import ComposableArchitecture
import NetworkKit

public final class RealtimeDIContainer {
    private let url: URL
    private let authManager: AuthManager
    
    public init(url: URL, authManager: AuthManager) {
        self.url = url
        self.authManager = authManager
    }
    
    private lazy var client: any RealtimeClientProtocol = {
        DefaultRealtimeClient(connection: connection)
    }()
    
    private lazy var connection: any RealtimeConnection = {
        URLSessionRealtimeConnection(
            configuration: configuration,
            authManager: authManager
        )
    }()
    
    private lazy var configuration: RealtimeConfiguration = {
        .init(url: url)
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.realtimeClient = .live(client: client)
    }
    
    
}
