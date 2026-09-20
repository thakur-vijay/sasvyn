//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

public struct User: Identifiable, Hashable, Sendable {
    public let id: String
    public let fullName: String
    public let email: String
    public let dateOfBirth: String?
    
    public init(id: String, fullName: String, email: String, dateOfBirth: String?) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.dateOfBirth = dateOfBirth
    }
}


