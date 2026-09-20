//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

internal struct LoginResponseDTO: Codable, Hashable, Sendable {
    let statusCode: Int
    let message: String
    let data: LoginDataDTO
}

internal struct LoginDataDTO: Codable, Hashable, Sendable {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
}

internal struct UserDTO: Codable, Hashable, Sendable {
    let id: String
    let appleId: String
    let fullName: String
    let email: String
    let dateOfBirth: String?
    let createdAt: String
    let updatedAt: String
    
    func toDomain()-> User {
        .init(
            id: id,
            fullName: fullName,
            email: email,
            dateOfBirth: dateOfBirth
        )
    }
}
