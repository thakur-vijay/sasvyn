//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct UpdateSkillEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SkillReponseDTO>
    
    let path: String
    
    let method: HTTPMethod = .put
    
    let body: RequestBody?
    
    let headers: [HTTPHeader]
    
    init(_ id: String, body: UpdateSkillDTO, idempotencyKey: String) {
        self.path = "/skills/\(id)"
        self.body = .json(body)
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
    
}
