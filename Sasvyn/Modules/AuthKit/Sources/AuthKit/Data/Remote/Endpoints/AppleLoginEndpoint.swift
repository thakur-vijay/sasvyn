//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

@preconcurrency import NetworkKit

internal struct AppleLoginEndpoint: Endpoint {
    typealias Response = LoginResponseDTO
    
    let path: String = "/auth/socialLogin"
    
    let method: HTTPMethod = .post
    
    let body: RequestBody?
    
    var requiresAuth: Bool = false
    
    init(_ body: LoginRequestDTO){
        self.body = .json(body)
    }
}
