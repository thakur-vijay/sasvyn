//
//  SVJSONDecoder.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 07/10/26.
//


import Foundation

public enum SVJSONDecoder {
    
    public static func make() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}