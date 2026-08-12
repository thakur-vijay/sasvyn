//
//  AppSymbol.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 31/07/26.
//


import Foundation

import SwiftUI

public struct AppSymbol: Sendable {

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

public enum AppSymbols {
    
}
