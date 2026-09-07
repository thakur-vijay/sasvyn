//
//  SVListRow.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 07/09/26.
//

import SwiftUI

public struct SVListRow<Leading: View, Trailing: View>: View {
    private let label: String
    private let value: String?
    private let leading: Leading
    private let trailing: Trailing
    private let showsDisclosureIndicator: Bool
    private let isDestructive: Bool
    private let action: () -> Void

    // MARK: - System Images

    public init(
        _ label: String,
        value: String? = nil,
        leadingImage: String? = nil,
        trailingImage: String? = nil,
        showsDisclosureIndicator: Bool = true,
        isDestructive: Bool = false,
        action: @escaping () -> Void = {}
    ) where Leading == AnyView, Trailing == AnyView {
        self.label = label
        self.value = value
        self.leading = AnyView(SVListRowSystemImage(name: leadingImage, isDestructive: isDestructive))
        self.trailing = AnyView(SVListRowSystemImage(name: trailingImage, isDestructive: isDestructive))
        self.showsDisclosureIndicator = showsDisclosureIndicator
        self.isDestructive = isDestructive
        self.action = action
    }

    // MARK: - Leading System Image + Custom Trailing

    public init(
        _ label: String,
        value: String? = nil,
        leadingImage: String? = nil,
        @ViewBuilder trailing: () -> Trailing,
        showsDisclosureIndicator: Bool = true,
        isDestructive: Bool = false,
        action: @escaping () -> Void = {}
    ) where Leading == AnyView {
        self.label = label
        self.value = value
        self.leading = AnyView(SVListRowSystemImage(name: leadingImage, isDestructive: isDestructive))
        self.trailing = trailing()
        self.showsDisclosureIndicator = showsDisclosureIndicator
        self.isDestructive = isDestructive
        self.action = action
    }

    // MARK: - Custom Leading + Trailing System Image

    public init(
        _ label: String,
        value: String? = nil,
        @ViewBuilder leading: () -> Leading,
        trailingImage: String? = nil,
        showsDisclosureIndicator: Bool = true,
        isDestructive: Bool = false,
        action: @escaping () -> Void = {}
    ) where Trailing == AnyView {
        self.label = label
        self.value = value
        self.leading = leading()
        self.trailing = AnyView(SVListRowSystemImage(name: trailingImage, isDestructive: isDestructive))
        self.showsDisclosureIndicator = showsDisclosureIndicator
        self.isDestructive = isDestructive
        self.action = action
    }

    // MARK: - Custom Views

    public init(
        _ label: String,
        value: String? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing,
        showsDisclosureIndicator: Bool = true,
        isDestructive: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.value = value
        self.leading = leading()
        self.trailing = trailing()
        self.showsDisclosureIndicator = showsDisclosureIndicator
        self.isDestructive = isDestructive
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12){
                leading

                Text(label)
                    .foregroundStyle(isDestructive ? .red : .primary)

                Spacer(minLength: 0)

                if let value {
                    Text(value)
                        .foregroundStyle(.secondary)
                }

                trailing

                if showsDisclosureIndicator {
                    SVListRowDisclosureIndicator()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)
    }
}

// MARK: - System Image

private struct SVListRowSystemImage: View {
    let name: String?
    let isDestructive: Bool

    var body: some View {
        if let name {
            Image(systemName: name)
                .font(.title3)
                .foregroundStyle(isDestructive ? .red : Color.accentColor)
        }
    }
}

// MARK: - Disclosure Indicator

private struct SVListRowDisclosureIndicator: View {
    var body: some View {
        Image(systemName: "chevron.forward")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.tertiary)
    }
}
