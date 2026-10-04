//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation

public struct CreateSocialLinkDTO: Encodable {
    public let id: String
    public let type: String
    public let url: String
    
    public init(id: String, type: String, url: String) {
        self.id = id
        self.type = type
        self.url = url
    }
}
