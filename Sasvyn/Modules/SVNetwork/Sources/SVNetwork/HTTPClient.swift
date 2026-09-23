//
//  HTTPClient.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//


import Foundation
import NetworkKit

public final class HTTPClient: HTTPDataTask {

    private let session: URLSession

    public init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    public func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse) {
        return try await session.data(
            for: request
        )
    }
}
