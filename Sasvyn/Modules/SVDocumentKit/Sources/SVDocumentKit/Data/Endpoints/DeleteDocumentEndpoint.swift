//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import NetworkKit
import SVNetwork

internal struct DeleteDocumentEndpoint: Endpoint {
    typealias Response = DataResponseDTO<DocumentResponseDTO>
    
    let path: String
    
    let method: HTTPMethod = .delete
    
    let headers: [HTTPHeader]
    
    init(
        _ id: String,
        idempotencyKey: String
    ) {
        self.path = "/documents/\(id)"
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
    
}
