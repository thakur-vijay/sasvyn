//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 23/09/26.
//

@preconcurrency import NetworkKit
import Foundation
import SVNetwork

internal struct UpdateUserEndpoint: Endpoint {
    typealias Response = DataResponseDTO<UserDTO>
    
    let path: String
    
    let method: HTTPMethod = .put
    
    var body: RequestBody?
    
    init(id: String, body: UpdateUserDTO) {
        self.path = "/users/\(id)"
        self.body = .json(body)
    }
}
