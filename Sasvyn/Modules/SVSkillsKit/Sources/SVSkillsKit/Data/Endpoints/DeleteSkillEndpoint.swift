//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct DeleteSkillEndpoint: Endpoint {
    typealias Response = MessageResponseDTO
    
    let path: String
    
    let method: HTTPMethod = .delete
    
    let headers: [HTTPHeader]
        
    init(_ id: String, idempotencyKey: String) {
        self.path = "/skills/\(id)"
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
}

