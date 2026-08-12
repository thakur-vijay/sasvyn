//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI

public struct SkillChip: View {
    private let skill: String
    private let background: Color
    private let isDeleteHidden: Bool
    private let onDelete: ()->()
    public init(skill: String, background: Color = Color(.systemGray6), isDeleteHidden: Bool = true, onDelete: @escaping ()->() = {}) {
        self.skill = skill
        self.background = background
        self.isDeleteHidden = isDeleteHidden
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(spacing: 6){
            Text(skill)
            if !isDeleteHidden {
                Image(systemName: "xmark")
            }
        }
        .font(.callout)
        .fontWeight(.semibold)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(background, in: .capsule)
        .contentShape(.rect)
        .onTapGesture {
            if !isDeleteHidden {
                onDelete()
            }
        }
    }
}
