//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchSkillsEndpoint: Endpoint {
    typealias Response = ListResponseDTO<SkillReponseDTO>
    
    let path: String = "/skills"
    
    let method: HTTPMethod = .get
}
