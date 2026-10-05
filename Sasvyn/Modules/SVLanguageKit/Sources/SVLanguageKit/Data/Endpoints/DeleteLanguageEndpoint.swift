//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct DeleteLanguageEndpoint: Endpoint {
    typealias Response = MessageResponseDTO

    let path: String

    let method: HTTPMethod = .delete

    let headers: [HTTPHeader]

    init(
        _ id: String,
        idempotencyKey: String
    ) {
        self.path = "/languages/\(id)"
        self.headers = [.idempotencyKey(idempotencyKey)]
    }
}
