//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import NetworkKit
import Foundation
import SVNetwork

internal struct FetchUserEndpoint: Endpoint {
    typealias Response = DataResponseDTO<UserDTO>
    
    let path: String
    
    let method: HTTPMethod = .get
    
    init(id: String) {
       path = "/users/\(id)"
    }
}
