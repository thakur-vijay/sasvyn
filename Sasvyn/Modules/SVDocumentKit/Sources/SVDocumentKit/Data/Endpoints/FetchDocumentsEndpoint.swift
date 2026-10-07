//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import NetworkKit
import SVNetwork

internal struct FetchDocumentsEndpoint: Endpoint {
    typealias Response = ListResponseDTO<DocumentResponseDTO>
    
    let path: String = "/documents"
    
    let method: HTTPMethod = .get
    
}
