//
//  File.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation

public struct MockupImage: Identifiable, Hashable, Sendable {
    public let id: String
    public let url: URL?
    public let thumbnail: URL?
    public let aspectRatio: Double

    public init(id: String, url: URL?, thumbnail: URL?, aspectRatio: Double) {
        self.id = id
        self.url = url
        self.thumbnail = thumbnail
        self.aspectRatio = aspectRatio
    }
}
