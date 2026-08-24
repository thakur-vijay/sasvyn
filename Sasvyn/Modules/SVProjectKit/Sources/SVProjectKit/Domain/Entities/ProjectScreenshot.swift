//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation

public struct ProjectScreenshot: Identifiable, Hashable, Sendable {
    public let id: String
    public let url: URL?
    public let order: Int
    
    public init(id: String, url: URL?, order: Int) {
        self.id = id
        self.url = url
        self.order = order
    }
}
