//
//  SocialLink.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//


import Foundation

public struct SocialLink: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public var type: LinkType?
    public var url: URL?

    public init(
        id: String,
        type: LinkType? = nil,
        url: URL? = nil,
    ) {
        self.id = id
        self.type = type
        self.url = url
    }
}
