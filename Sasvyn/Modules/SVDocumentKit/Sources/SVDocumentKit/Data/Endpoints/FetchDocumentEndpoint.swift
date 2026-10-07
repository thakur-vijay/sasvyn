//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import NetworkKit
import SVNetwork

internal struct FetchDocumentEndpoint: Endpoint {
    typealias Response = DataResponseDTO<DocumentResponseDTO>
    
    let path: String
    
    let method: HTTPMethod = .get
    
    init(_ id: String) {
        self.path = "/documents/\(id)"
    }
    
}
