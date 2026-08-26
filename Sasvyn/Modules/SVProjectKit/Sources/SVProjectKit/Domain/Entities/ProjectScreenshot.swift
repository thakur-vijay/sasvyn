//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation
import SVDesignSystem

public struct ProjectScreenshot: Identifiable, Codable, Hashable, Sendable, ImageViewerItem{
    public let id: String
    public var mockupID: String
    public var device: String
    public var imageURL: URL?
    public var aspectRatio: Double
    public var order: Int

    public init(id: String, mockupID: String, device: String, imageURL: URL?, aspectRatio: CGFloat, order: Int) {
        self.id = id
        self.mockupID = mockupID
        self.device = device
        self.imageURL = imageURL
        self.aspectRatio = aspectRatio
        self.order = order
    }

}
