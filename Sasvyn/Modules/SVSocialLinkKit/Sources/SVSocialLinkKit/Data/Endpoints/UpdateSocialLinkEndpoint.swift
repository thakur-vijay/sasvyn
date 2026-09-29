//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct UpdateSocialLinkEndpoint: Endpoint {
    typealias Response = MessageResponseDTO
    
    let path: String
    
    let method: HTTPMethod = .put
    
    let body: RequestBody?
    
    init(_ id: String, body: UpdateSocialLinkDTO) {
        self.path = "/socialLinks/\(id)"
        self.body = .json(body)
    }
    
    
}
