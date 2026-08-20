//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI

@available(iOS 18.0, *)
public struct SVEditableText: View {
    @Binding var description: String
    private let placeholder: String
    private let isExpandable: Bool
    private let collapsedLineLimit: Int
    private let characterLimit: Int
    private let isEditable: Bool
    
    public init(
        description: Binding<String>,
        placeholder: String,
        isExpandable: Bool = true,
        collapsedLineLimit: Int = 2,
        characterLimit: Int,
        isEditable: Bool = false
    ) {
        self._description = description
        self.placeholder = placeholder
        self.isExpandable = isExpandable
        self.characterLimit = characterLimit
        self.collapsedLineLimit = collapsedLineLimit
        self.isEditable = isEditable
    }
    
    public var body: some View {
        Group {
            if isEditable {
                TextField("", text: $description, prompt: Text(placeholder), axis: isExpandable ? .vertical : .horizontal)
                    .onChange(of: description) { _, newValue in
                        guard newValue.count > characterLimit else { return }
                        description = String(newValue.prefix(characterLimit))
                    }
            }else {
                Text(description)
                    .expandable(
                        isEnabled: isExpandable,
                        length: collapsedLineLimit,
                        blurRadius: 0,
                        animation: .smooth(duration: 0.15)
                    )
            }
        }
        .font(.callout)
    }
}
