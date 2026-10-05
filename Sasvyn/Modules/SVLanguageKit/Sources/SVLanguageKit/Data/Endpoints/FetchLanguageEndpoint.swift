//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct FetchLanguageEndpoint: Endpoint {
    typealias Response = DataResponseDTO<LanguageResponseDTO>

    let path: String

    let method: HTTPMethod = .get

    init(
        _ id: String,
    ) {
        self.path = "/languages/\(id)"
    }
}
