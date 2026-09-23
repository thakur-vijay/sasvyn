//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct User: Identifiable, Hashable, Sendable{
    public let id: String
    public let appleId: String
    public var fullName: String
    public var email: String
    public var dateOfBirth: Date?
    public var imageLocalUrl: URL?
    public var imageUrl: String?
    
    public init(
        id: String,
        appleId: String,
        fullName: String,
        email: String,
        dateOfBirth: Date? = nil,
        imageLocalUrl: URL? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.appleId = appleId
        self.fullName = fullName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.imageLocalUrl = imageLocalUrl
        self.imageUrl = imageUrl
    }
    
}
