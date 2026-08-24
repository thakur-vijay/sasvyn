//
//  Mockup.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation

public struct Mockup: Identifiable, Hashable, Sendable{
    public let id: String
    public var device: Device
    public var imageData: Data
    public var imageResize: ImageScaleResize
    
    public init(
        id: String,
        device: Device,
        imageData: Data,
        imageResize: ImageScaleResize
    ) {
        self.id = id
        self.device = device
        self.imageData = imageData
        self.imageResize = imageResize
    }
}
