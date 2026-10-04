//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct DeleteSocialLinkEndpoint: Endpoint {
    typealias Response = MessageResponseDTO

    let path: String

    let method: HTTPMethod = .delete

    let headers: [HTTPHeader]

    init(
        _ id: String,
        idempotencyKey: String
    ) {
        self.path = "/socialLinks/\(id)"
        self.headers = [
            .init(
                name: "Idempotency-Key",
                value: idempotencyKey
            )
        ]
    }
}

