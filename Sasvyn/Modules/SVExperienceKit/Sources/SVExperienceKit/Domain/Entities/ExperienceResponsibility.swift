//
//  File.swift
//  SVExperienceKit
//
//  Created by Vijay Thakur on 01/09/26.
//

import Foundation

public struct ExperienceResponsibility: Identifiable, Hashable, Sendable {
    public let id: String
    public let experienceID: String
    public var responsibility: String
    public init(id: String, experienceID: String, responsibility: String) {
        self.id = id
        self.experienceID = experienceID
        self.responsibility = responsibility
    }
}
