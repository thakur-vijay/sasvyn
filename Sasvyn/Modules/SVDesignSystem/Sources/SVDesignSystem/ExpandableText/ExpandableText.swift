//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 17/08/26.
//

import SwiftUI

@available(iOS 18.0, *)
extension View {
    @ViewBuilder
    public func expandable(
        isEnabled: Bool = true,
        length: Int,
        moreText: String = "...More",
        blurRadius: CGFloat = 2,
        animation: Animation
    ) -> some View {
        if isEnabled {
            self
                .modifier(
                    ExpandableTextModifier(
                        length: length,
                        moreText: moreText,
                        blurRadius: blurRadius,
                        animation: animation
                    )
                )
        }else {
            self
        }
    }
    
    @ViewBuilder
    internal func optionalClip(blurRadius: CGFloat)-> some View {
        if blurRadius.isZero {
            self
                .clipped()
        }else {
            self
        }
    }
}
