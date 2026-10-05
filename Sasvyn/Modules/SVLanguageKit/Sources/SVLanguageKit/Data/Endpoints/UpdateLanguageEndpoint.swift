//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct UpdateLanguageEndpoint: Endpoint {
    typealias Response = DataResponseDTO<LanguageResponseDTO>

    let path: String

    let method: HTTPMethod = .put

    let body: RequestBody?

    let headers: [HTTPHeader]

    init(
        _ id: String,
        body: UpdateLanguageDTO,
        idempotencyKey: String
    ) {
        self.path = "/languages/\(id)"
        self.body = .json(body)
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
}
