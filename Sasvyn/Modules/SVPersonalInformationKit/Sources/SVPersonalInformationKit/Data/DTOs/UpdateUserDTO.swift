//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct UpdateUserDTO: Codable, Hashable, Sendable {
    public let fullName: String?
    public let dateOfBirth: String?
    public let imageKey: String?
    
    public enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case dateOfBirth = "date_of_birth"
        case imageKey = "img_key"
    }
    
    public init(fullName: String?, dateOfBirth: String?, imageKey: String?) {
        self.fullName = fullName
        self.dateOfBirth = dateOfBirth
        self.imageKey = imageKey
    }
}
