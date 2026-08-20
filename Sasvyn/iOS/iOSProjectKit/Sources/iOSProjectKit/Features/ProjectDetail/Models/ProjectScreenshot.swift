//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import Foundation

public struct ProjectScreenshot: Identifiable, Equatable {
    public let id: UUID
    public var imageURL: URL?
    public var order: Int

    public init(
        id: UUID = UUID(),
        imageURL: URL? = nil,
        order: Int
    ) {
        self.id = id
        self.imageURL = imageURL
        self.order = order
    }
}
