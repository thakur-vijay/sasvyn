//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 19/08/26.
//

import Foundation

public struct SVChipModel: Identifiable {
    public let id: String
    public let text: String
    
    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}
