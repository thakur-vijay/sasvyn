//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

public struct LoginRequestDTO: Codable, Hashable, Sendable{
    public let appleId: String
    public let fullName: String
    public let email: String

    public init(appleId: String, fullName: String, email: String) {
        self.appleId = appleId
        self.fullName = fullName
        self.email = email
    }
}
