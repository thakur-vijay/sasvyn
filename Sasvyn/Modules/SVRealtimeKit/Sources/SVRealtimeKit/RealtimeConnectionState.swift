//
//  RealtimeConnectionState.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public enum RealtimeConnectionState: Sendable {
    case disconnected
    case connecting
    case connected
    case disconnecting
}
