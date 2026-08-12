//
//  SVSpacing.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 12/08/26.
//

import SwiftUI

public enum SVSpacing {

    // MARK: - Base Scale

    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 24
    public static let xxLarge: CGFloat = 32
    public static let xxxLarge: CGFloat = 40

    // MARK: - Screen

    /// Horizontal inset for the main screen content.
    public static let screenHorizontal: CGFloat = 20

    /// Vertical spacing between major screen content.
    public static let screenVertical: CGFloat = 24

    /// Standard screen content padding.
    public static let screen: CGFloat = 20

    // MARK: - Section

    /// Spacing between major sections.
    public static let section: CGFloat = 32

    /// Spacing between a section title and its content.
    public static let sectionContent: CGFloat = 12

    // MARK: - Card

    /// Internal padding for cards.
    public static let card: CGFloat = 16

    /// Spacing between elements inside a card.
    public static let cardContent: CGFloat = 12

    // MARK: - Row

    /// Horizontal padding for standard rows.
    public static let rowHorizontal: CGFloat = 16

    /// Vertical padding for standard rows.
    public static let rowVertical: CGFloat = 12

    /// Spacing between elements inside a row.
    public static let rowContent: CGFloat = 12

    // MARK: - Content

    /// Spacing between closely related content.
    public static let content: CGFloat = 8

    /// Spacing between loosely related content.
    public static let contentLarge: CGFloat = 16

    // MARK: - Control

    /// Internal horizontal padding for controls such as buttons.
    public static let controlHorizontal: CGFloat = 16

    /// Internal vertical padding for controls.
    public static let controlVertical: CGFloat = 10
}
