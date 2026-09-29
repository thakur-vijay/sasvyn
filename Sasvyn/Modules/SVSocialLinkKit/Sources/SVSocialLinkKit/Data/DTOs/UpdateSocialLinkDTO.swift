//
//  CreateSocialLinkDTO 2.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//


import Foundation

public struct UpdateSocialLinkDTO: Encodable {
    public let type: String
    public let url: String
    
    public init(type: String, url: String) {
        self.type = type
        self.url = url
    }
}
