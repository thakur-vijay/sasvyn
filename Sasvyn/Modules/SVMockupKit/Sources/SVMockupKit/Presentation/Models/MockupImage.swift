//
//  File.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation
import SVDesignSystem

public struct MockupImage: Identifiable, Hashable, Sendable, ImageViewerItem{
    public let id: String
    public let device: String
    public let url: URL?
    public let thumbnail: URL?
    public let aspectRatio: Double
    
    public var imageURL: URL?{
        url
    }

    public init(id: String, device: String, url: URL?, thumbnail: URL?, aspectRatio: Double) {
        self.id = id
        self.device = device
        self.url = url
        self.thumbnail = thumbnail
        self.aspectRatio = aspectRatio
    }
}
