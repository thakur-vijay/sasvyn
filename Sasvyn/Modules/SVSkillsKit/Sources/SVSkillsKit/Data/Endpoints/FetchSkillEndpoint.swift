//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchSkillEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SkillReponseDTO>
    
    let path: String
    
    let method: HTTPMethod = .get
        
    init(_ id: String) {
        self.path = "/skills/\(id)"
    }
}

