//
//  SVSymbol.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 04/09/26.
//

import SwiftUI

public struct SVSymbol: Sendable {

    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    public var image: Image {
        Image(systemName: name)
    }

#if canImport(UIKit)
    
    public var uiImage: UIImage? {
        
        UIImage(systemName: name)
        
    }
    
#endif
}
