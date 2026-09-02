//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 01/09/26.
//

import Foundation

public struct WebItem: Identifiable {
    public let url: URL
    public let title: String?
    
    public var id: String { url.absoluteString }
    
    public init(url: URL, title: String? = nil) {
        self.url = url
        self.title = title
    }
}
