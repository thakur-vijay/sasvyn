//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct CreateSocialLinkEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SocialLinkReponseDTO>
    
    let path: String = "/socialLinks"
    
    let method: HTTPMethod = .post
    
    let body: RequestBody?
    
    init(_ body: CreateSocialLinkDTO) {
        self.body = .json(body)
    }
    
    
}
