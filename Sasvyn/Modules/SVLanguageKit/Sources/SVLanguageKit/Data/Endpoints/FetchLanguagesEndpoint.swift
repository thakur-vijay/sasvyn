//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchLanguagesEndpoint: Endpoint {
    typealias Response = ListResponseDTO<LanguageResponseDTO>

    let path: String = "/languages"

    let method: HTTPMethod = .get

}
