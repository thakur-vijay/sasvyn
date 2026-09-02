//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 02/09/26.
//

import SwiftUI

public struct SVGradientText: View {
    private let text: String
    private let colors: [Color]
    private let start: UnitPoint
    private let end: UnitPoint

    public init(
        text: String,
        colors: [Color],
        start: UnitPoint = .leading,
        end: UnitPoint = .trailing
    ) {
        self.text = text
        self.colors = colors
        self.start = start
        self.end = end
    }

    public var body: some View {
        Text(text)
            .foregroundStyle(
                LinearGradient(
                    colors: colors,
                    startPoint: start,
                    endPoint: end
                )
            )
    }
}
