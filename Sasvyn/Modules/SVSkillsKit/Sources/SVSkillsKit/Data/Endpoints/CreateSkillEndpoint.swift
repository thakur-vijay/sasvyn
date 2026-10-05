//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct CreateSkillEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SkillReponseDTO>
    
    let path: String = "/skills"
    
    let method: HTTPMethod = .post
    
    let body: RequestBody?
    
    let headers: [HTTPHeader]
    
    init(_ body: CreateSkillDTO, idempotencyKey: String) {
        self.body = .json(body)
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
    
}
