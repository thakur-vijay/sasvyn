//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct CreateLanguageEndpoint: Endpoint {
    typealias Response = DataResponseDTO<LanguageResponseDTO>

    let path: String = "/languages"

    let method: HTTPMethod = .post

    let body: RequestBody?

    let headers: [HTTPHeader]

    init(
        _ body: CreateLanguageDTO,
        idempotencyKey: String
    ) {
        self.body = .json(body)
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
}
