//
//  File.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct DataResponseDTO<T: Codable & Hashable & Sendable>: Codable, Hashable, Sendable {
    public let statusCode: Int
    public let message: String
    public let data: T
}

public struct ListResponseDTO<T: Codable & Hashable & Sendable>: Codable, Hashable, Sendable {
    public let statusCode: Int
    public let message: String
    public let data: [T]
}

public struct MessageResponseDTO: Codable, Hashable, Sendable {
    public let statusCode: Int
    public let message: String
}
