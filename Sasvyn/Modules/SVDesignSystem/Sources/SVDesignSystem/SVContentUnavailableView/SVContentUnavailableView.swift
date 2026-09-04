//
//  SVContentUnavailableView.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI

public struct SVContentUnavailableView<Actions: View>: View {

    private let title: String
    private let description: String
    private let symbol: SVSymbol
    private let actions: Actions

    public init(
        title: String,
        symbol: SVSymbol,
        description: String,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.symbol = symbol
        self.description = description
        self.actions = actions()
    }

    public var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
            } icon: {
                symbol.image
                    .foregroundStyle(Color.accentColor)
            }

        } description: {
            Text(description)
        } actions: {
            actions
        }
    }
}

public extension SVContentUnavailableView where Actions == EmptyView {

    init(
        title: String,
        symbol: SVSymbol,
        description: String
    ) {
        self.init(
            title: title,
            symbol: symbol,
            description: description
        ) {
            EmptyView()
        }
    }
}
