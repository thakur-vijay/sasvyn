//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 17/08/26.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func disabledWithOpacity(_ isDisabled: Bool)-> some View {
        self
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)
    }
    
    @ViewBuilder
    nonisolated func optionalGlassEffect<S: Shape & Sendable>(_ shape: S, isInteractive: Bool = false)-> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.clear.interactive(isInteractive), in: shape)
        } else {
           self
                .background(.ultraThinMaterial, in: shape)
        }
    }
    
    @ViewBuilder
    func optionalContextMenu<M, P>(
        _ isEnabled: Bool,
        isPreviewHidden: Bool,
        @ContentBuilder menuItems: () -> M,
        @ContentBuilder preview: () -> P
    ) -> some View where M : View, P : View {
        if isEnabled {
            if isPreviewHidden {
                self
                    .contextMenu(menuItems: menuItems)
            }else {
                self
                    .contextMenu(menuItems: menuItems, preview: preview)
            }
        }else {
            self
        }
    }
}
