//
//  ImageViewerItem.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 26/08/26.
//

import Foundation

public protocol ImageViewerItem: Identifiable where ID == String {
    var imageURL: URL? { get }
    var aspectRatio: Double { get }
}
