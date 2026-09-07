//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 07/09/26.
//

import Foundation

public enum PersonalInformationDestination: String, Identifiable, Codable, Hashable, Sendable {
    public var id: String { rawValue }
    case name = "Name"
    case email = "Email"
    case dateOfBirth = "Date of Birth"
    case phoneNo = "Phone No."
}
