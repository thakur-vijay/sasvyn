//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 30/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchSocialLinkEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SocialLinkReponseDTO>
    
    let path: String
    
    let method: HTTPMethod = .get
    
    init(_ id: String) {
        self.path = "/socialLinks/\(id)"
    }

}
