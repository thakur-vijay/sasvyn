//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation

internal struct LanguageResponseDTO: Codable, Sendable, Hashable{
    let id: String
    let userId: String
    let languageCode: String
    let language: String
    let proficiency: String
    let syncVersion: Int64
    let createdAt: Date
    let updatedAt: Date
}
