//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct CreateDocumentEndpoint: Endpoint {
    typealias Response = DataResponseDTO<DocumentResponseDTO>
    
    let path: String = "/documents"
    
    let method: HTTPMethod = .post
    
    let body: RequestBody?
    
    let headers: [HTTPHeader]
    
    init(
        _ body: CreateDocumentDTO,
        idempotencyKey: String
    ) {
        self.body = .json(body)
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
    
}
