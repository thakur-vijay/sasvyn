//
//  UserDTO.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import Foundation

internal struct UserDTO: Codable, Hashable, Sendable {
    let id: String
    let appleId: String
    let fullName: String
    let email: String
    let dateOfBirth: Date?
    let imgUrl: String?
    let createdAt: Date
    let updatedAt: Date
    let syncVersion: Int64
    
    func toDomain()-> User {
        .init(
            id: id,
            appleId: appleId,
            fullName: fullName,
            email: email,
            dateOfBirth: dateOfBirth,
            imageUrl: imgUrl,
            serverVersion: syncVersion,
            updatedAt: updatedAt
        )
    }
}
