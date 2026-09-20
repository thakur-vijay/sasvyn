//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import os

public struct NetworkLogger: NetworkLogging {

    private let logger = Logger(
        subsystem: "com.vijaythakur.Sasvyn",
        category: "Networking"
    )

    public init() {}

    public func logRequest(_ request: URLRequest) async {

        var components: [String] = []

        if let method = request.httpMethod {
            components.append(method)
        }

        if let url = request.url?.absoluteString {
            components.append(url)
        }

        logger.debug(
            "➡️ Request: \(components.joined(separator: " "))"
        )

        if !(request.allHTTPHeaderFields?.isEmpty ?? false) {
            let headers = request.allHTTPHeaderFields?
                .filter { key, _ in
                    let key = key.lowercased()

                    return key != "authorization"
                        && key != "cookie"
                        && key != "set-cookie"
                }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: ", ")

            if let headers, !headers.isEmpty {
                logger.debug("Headers: \(headers)")
            }
        }
    }

    public func logResponse(
        _ response: HTTPURLResponse?,
        data: Data?,
        duration: TimeInterval,
        error: (any Error)?
    ) {

        let statusCode = response?.statusCode ?? 0
        let url = response?.url?.absoluteString ?? "Unknown URL"
        let durationMs = Int(duration * 1000)

        if let error {
            logger.error(
                "❌ Response failed: \(url) | status: \(statusCode) | duration: \(durationMs)ms | error: \(error.localizedDescription)"
            )
            return
        }

        logger.debug(
            "⬅️ Response: \(statusCode) | \(url) | duration: \(durationMs)ms"
        )

        if let data {
            logger.debug(
                "Response size: \(data.count) bytes"
            )
        }
    }
}
