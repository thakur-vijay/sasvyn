//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
@preconcurrency import NetworkKit
import SVNetwork

internal struct UpdateSocialLinkEndpoint: Endpoint {
    typealias Response = DataResponseDTO<SocialLinkReponseDTO>

    let path: String

    let method: HTTPMethod = .put

    let body: RequestBody?

    let headers: [HTTPHeader]

    init(
        _ id: String,
        body: UpdateSocialLinkDTO,
        idempotencyKey: String
    ) {
        self.path = "/socialLinks/\(id)"
        self.body = .json(body)
        self.headers = [
            .init(
                name: "Idempotency-Key",
                value: idempotencyKey
            )
        ]
    }
}
