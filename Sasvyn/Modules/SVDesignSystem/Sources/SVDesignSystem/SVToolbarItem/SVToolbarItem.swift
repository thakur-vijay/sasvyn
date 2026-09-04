//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 04/09/26.
//

import SwiftUI

public struct SVToolbarItem: ToolbarContent {
    
    private let symbol: SVSymbol
    private let placement: ToolbarItemPlacement
    private let isEnabled: Bool
    private let action: () -> Void

    public init(
        symbol: SVSymbol,
        placement: ToolbarItemPlacement,
        action: @escaping () -> Void
    ) {
        self.symbol = symbol
        self.placement = placement
        self.isEnabled = true
        self.action = action
    }
    
    private init(
        symbol: SVSymbol,
        placement: ToolbarItemPlacement,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) {
        self.symbol = symbol
        self.placement = placement
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                symbol.image
                    .foregroundStyle(Color.accentColor)
            }
            .tint(isEnabled ? .accentColor : .gray.opacity(0.3))
            .disabledWithOpacity(!isEnabled)
        }
    }
}

public extension SVToolbarItem {

    static func close(
        action: @escaping () -> Void
    ) -> SVToolbarItem {
        SVToolbarItem(
            symbol: SVSymbols.close,
            placement: .topBarLeading,
            action: action
        )
    }

    static func check(
        _ isEnabled: Bool,
        action: @escaping () -> Void
    ) -> SVToolbarItem {
        SVToolbarItem(
            symbol: SVSymbols.Check.plain,
            placement: .topBarTrailing,
            isEnabled: isEnabled,
            action: action
        )
    }
    
    static func check(
        action: @escaping () -> Void
    ) -> SVToolbarItem {
        SVToolbarItem(
            symbol: SVSymbols.Check.plain,
            placement: .topBarTrailing,
            isEnabled: true,
            action: action
        )
    }
}


