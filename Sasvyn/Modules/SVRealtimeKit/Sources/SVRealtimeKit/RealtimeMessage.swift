//
//  RealtimeMessage.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public struct RealtimeMessage: Codable, Sendable {
    public let type: RealtimeEvent
    public let data: AnyCodable
}


public enum AnyCodable: Codable, Sendable, Equatable, Hashable {
    
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([AnyCodable])
    case object([String: AnyCodable])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([AnyCodable].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self = .object(value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported JSON value"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .null:
            try container.encodeNil()
            
        case let .bool(value):
            try container.encode(value)
            
        case let .int(value):
            try container.encode(value)
            
        case let .double(value):
            try container.encode(value)
            
        case let .string(value):
            try container.encode(value)
            
        case let .array(value):
            try container.encode(value)
            
        case let .object(value):
            try container.encode(value)
        }
    }
}
