//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 21/09/26.
//

@preconcurrency import NetworkKit

internal struct LogoutEndpoint: Endpoint {
    typealias Response = LogoutResponseDTO
    
    let path: String = "/auth/logout"
    
    let method: HTTPMethod = .post
}
