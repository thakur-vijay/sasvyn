//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 19/08/26.
//

import SwiftUI

public struct SVChip: View {
    private let model: SVChipModel
    private let isSelected: Bool
    private let action: ()->()
    
    public init(model: SVChipModel, isSelected: Bool, action: @escaping ()->()) {
        self.model = model
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Text(model.text)
            .font(.subheadline)
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? .purple : Color(.secondarySystemBackground), in: .capsule)
            .optionalGlassEffect(.capsule)
            .contentShape(.rect)
            .contentShape(.contextMenuPreview, .capsule)
            .id(model.id)
            .onTapGesture {
               action()
            }
    }
}
