//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 19/08/26.
//

import SwiftUI

public struct SVChip: View {
    private let model: SVChipModel
    private let font: Font
    private let isSelected: Bool
    private let action: ()->()
    
    public init(
        model: SVChipModel,
        font: Font = .subheadline,
        isSelected: Bool,
        action: @escaping ()->()
    ) {
        self.model = model
        self.font = font
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Text(model.text)
            .font(font)
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.accentColor : Color(.secondarySystemBackground),
                in: .capsule
            )
            .optionalGlassEffect(.capsule)
            .contentShape(.rect)
            .contentShape(.contextMenuPreview, .capsule)
            .id(model.id)
            .onTapGesture {
               action()
            }
    }
}
