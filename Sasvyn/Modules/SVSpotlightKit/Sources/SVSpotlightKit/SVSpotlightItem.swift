//
//  SVSpotlightItem.swift
//  SVSpotlightKit
//
//  Created by Vijay Thakur on 05/09/26.
//

import Foundation

public struct SVSpotlightItem: Sendable, Equatable {
    public let destination: SVSpotlightDestination
    public let title: String
    public let description: String?
    public let keywords: [String]
    public let domainIdentifier: String

    public init(
        destination: SVSpotlightDestination,
        title: String,
        description: String? = nil,
        keywords: [String] = [],
        domainIdentifier: String
    ) {
        self.destination = destination
        self.title = title
        self.description = description
        self.keywords = keywords
        self.domainIdentifier = domainIdentifier
    }
}
