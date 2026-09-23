//
//  AuthSession.swift
//  AuthKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import Foundation

public struct AuthSession: Equatable, Sendable {
    public let userID: String
    
    public init(userID: String) {
        self.userID = userID
    }
}
