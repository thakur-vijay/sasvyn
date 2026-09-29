//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchSocialLinksEndpoint: Endpoint {
    typealias Response = ListResponseDTO<SocialLinkReponseDTO>
    
    let path: String = "/socialLinks"
    
    let method: HTTPMethod = .get
    
}
