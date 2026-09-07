//
//  SVItem.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 07/09/26.
//

import SwiftUI

public struct SVItem {
    public let label: String
    public let value: String?
    public let leadingImage: String?
    public let trailingImage: String?
    public let leadingIcon: AnyView?
    public let trailingIcon: AnyView?
    public let navigationLinkIndicatorVisibility: Visibility
    
    public init(
        label: String,
        value: String? = nil,
        leadingImage: String? = nil,
        trailingImage: String? = nil,
        leadingIcon: AnyView? = nil,
        trailingIcon: AnyView? = nil,
        navigationLinkIndicatorVisibility: Visibility = .visible
    ) {
        self.label = label
        self.value = value
        self.leadingImage = leadingImage
        self.trailingImage = trailingImage
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.navigationLinkIndicatorVisibility = navigationLinkIndicatorVisibility
    }
}
