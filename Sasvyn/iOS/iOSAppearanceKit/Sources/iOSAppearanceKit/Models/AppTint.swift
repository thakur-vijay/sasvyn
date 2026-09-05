//
//  AppTint.swift
//  iOSAppearanceKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI

public enum AppTint: String, CaseIterable, Identifiable {
    case azure
    case cyan
    case teal
    case green
    case gold
    case orange
    case red
    case rose
    case magenta
    case purple
    case indigo
    case violet

    public var id: Self { self }

    public var color: Color {
        switch self {
        case .azure:
            .blue
                .mix(with: .indigo, by: 0.18)
                .mix(with: .black, by: 0.08)

        case .cyan:
            .cyan
                .mix(with: .blue, by: 0.22)
                .mix(with: .black, by: 0.18)

        case .teal:
            .teal
                .mix(with: .blue, by: 0.12)
                .mix(with: .black, by: 0.12)

        case .green:
            .green
                .mix(with: .teal, by: 0.16)
                .mix(with: .black, by: 0.10)

        case .gold:
            .yellow
                .mix(with: .orange, by: 0.38)
                .mix(with: .black, by: 0.38)

        case .orange:
            .orange
                .mix(with: .red, by: 0.12)
                .mix(with: .black, by: 0.12)

        case .red:
            .red
                .mix(with: .orange, by: 0.08)
                .mix(with: .black, by: 0.08)

        case .rose:
            .pink
                .mix(with: .red, by: 0.22)
                .mix(with: .black, by: 0.10)

        case .magenta:
            .pink
                .mix(with: .purple, by: 0.32)
                .mix(with: .black, by: 0.10)

        case .purple:
            .purple
                .mix(with: .pink, by: 0.12)
                .mix(with: .black, by: 0.08)

        case .indigo:
            .indigo
                .mix(with: .purple, by: 0.18)
                .mix(with: .black, by: 0.05)

        case .violet:
            .purple
                .mix(with: .blue, by: 0.18)
                .mix(with: .black, by: 0.12)
        }
    }
}
