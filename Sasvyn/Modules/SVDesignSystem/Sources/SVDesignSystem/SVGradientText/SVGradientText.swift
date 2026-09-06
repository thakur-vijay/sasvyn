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
    private let isAnimationEnabled: Bool
    private let speed: Double

    public init(
        text: String,
        colors: [Color],
        isAnimationEnabled: Bool = true,
        speed: Double = 0.10
    ) {
        guard (0.05...0.25).contains(speed) else {
            fatalError(
                "SVGradientText speed must be between 0.05 and 0.25."
            )
        }
        self.text = text
        self.colors = colors
        self.isAnimationEnabled = isAnimationEnabled
        self.speed = speed
    }

    public var body: some View {
        Group {
            if isAnimationEnabled {
                TimelineView(.animation) { timeline in
                    mesh(at: timeline.date.timeIntervalSinceReferenceDate)
                }
            } else {
                mesh(at: 0)
            }
        }
    }
}

// MARK: - Mesh

private extension SVGradientText {

    @ViewBuilder
    func mesh(at time: TimeInterval) -> some View {
        Text(text)
            .foregroundStyle(MeshGradient(
                width: 3,
                height: 3,
                points: meshPoints,
                colors: meshColors(at: time)
            ))
    }

    var meshPoints: [SIMD2<Float>] {
        [
            SIMD2(0.0, 0.0),
            SIMD2(0.5, 0.0),
            SIMD2(1.0, 0.0),

            SIMD2(0.0, 0.5),
            SIMD2(0.5, 0.5),
            SIMD2(1.0, 0.5),

            SIMD2(0.0, 1.0),
            SIMD2(0.5, 1.0),
            SIMD2(1.0, 1.0)
        ]
    }

    func meshColors(at time: TimeInterval) -> [Color] {
        guard !colors.isEmpty else {
            return Array(repeating: .clear, count: 9)
        }

        let phase = CGFloat(
            (time * speed)
                .truncatingRemainder(dividingBy: 1)
        )

        return (0..<9).map { index in
            let normalizedPosition = CGFloat(index) / 8

            // Clockwise
            let position = (normalizedPosition - phase)
                .truncatingRemainder(dividingBy: 1)
                .wrapped

            return interpolatedColor(at: position)
        }
    }

    func interpolatedColor(at position: CGFloat) -> Color {
        guard colors.count > 1 else {
            return colors[0]
        }

        let scaled = position * CGFloat(colors.count)
        let lowerIndex = Int(scaled) % colors.count
        let upperIndex = (lowerIndex + 1) % colors.count
        let amount = scaled - floor(scaled)

        return colors[lowerIndex]
            .interpolated(
                to: colors[upperIndex],
                amount: amount
            )
    }
}

// MARK: - Color Interpolation

private extension Color {

    func interpolated(
        to color: Color,
        amount: CGFloat
    ) -> Color {
        let amount = min(max(amount, 0), 1)

        #if os(iOS)
        let lhs = UIColor(self)
        let rhs = UIColor(color)

        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0

        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0

        lhs.getRed(
            &r1,
            green: &g1,
            blue: &b1,
            alpha: &a1
        )

        rhs.getRed(
            &r2,
            green: &g2,
            blue: &b2,
            alpha: &a2
        )

        return Color(
            red: r1 + (r2 - r1) * amount,
            green: g1 + (g2 - g1) * amount,
            blue: b1 + (b2 - b1) * amount,
            opacity: a1 + (a2 - a1) * amount
        )
        #else
        return self
        #endif
    }
}

private extension CGFloat {
    var wrapped: CGFloat {
        self >= 0 ? self : self + 1
    }
}
