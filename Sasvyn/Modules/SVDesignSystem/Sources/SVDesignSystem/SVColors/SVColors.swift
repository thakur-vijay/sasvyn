//
//  SwiftUIView.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI

public enum SVColors {

    // MARK: - Content

    /// Primary content color.
    public static let primaryText = Color.primary

    /// Secondary content color.
    public static let secondaryText = Color.secondary

    /// Accent color used for interactive elements.
    public static let accent = Color.accentColor

    // MARK: - Background

    /// Primary app background.
    public static let background = Color(.systemBackground)

    /// Secondary background for grouped/content surfaces.
    public static let secondaryBackground = Color(.secondarySystemBackground)

    /// Tertiary background for nested surfaces.
    public static let tertiaryBackground = Color(.tertiarySystemBackground)

    // MARK: - Fill

    /// Primary system fill.
    public static let fill = Color(.systemFill)

    /// Secondary system fill.
    public static let secondaryFill = Color(.secondarySystemFill)

    /// Tertiary system fill.
    public static let tertiaryFill = Color(.tertiarySystemFill)

    /// Quaternary system fill.
    public static let quaternaryFill = Color(.quaternarySystemFill)

    // MARK: - Separator

    /// Standard system separator.
    public static let separator = Color(.separator)

    // MARK: - Status

    public static let success = Color.green
    public static let warning = Color.orange
    public static let error = Color.red
    public static let info = Color.blue

    // MARK: - Utility

    public static let clear = Color.clear
}
