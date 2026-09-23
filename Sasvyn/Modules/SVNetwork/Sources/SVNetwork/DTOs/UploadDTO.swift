//
//  File.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public struct CreateUploadDTO: Codable, Hashable, Sendable {
    public let type: String
    public let contentType: String
    
    public init(type: String, contentType: String) {
        self.type = type
        self.contentType = contentType
    }
}

public struct UploadDTO: Codable, Hashable, Sendable {
    public let uploadUrl: String
    public let imgKey: String
}
