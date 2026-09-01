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
    private let font: Font
    private let placeholderStyle: Color
    private let foregroundStyle: Color
    private let keyboardType: UIKeyboardType
    private let contentType: UITextContentType
    private let onEditingEnded: ()->()
    
    public init(
        description: Binding<String>,
        placeholder: String,
        isExpandable: Bool = true,
        collapsedLineLimit: Int = 2,
        characterLimit: Int,
        isEditable: Bool = false,
        font: Font = .caption,
        placeholderStyle: Color = Color(.placeholderText),
        foregroundStyle: Color = Color.primary,
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType = .name,
        onEditingEnded: @escaping ()->()
    ) {
        self._description = description
        self.placeholder = placeholder
        self.isExpandable = isExpandable
        self.characterLimit = characterLimit
        self.collapsedLineLimit = collapsedLineLimit
        self.isEditable = isEditable
        self.font = font
        self.placeholderStyle = placeholderStyle
        self.foregroundStyle = foregroundStyle
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.onEditingEnded = onEditingEnded
    }
    
    @State private var debounceTask: Task<Void, Never>?
    
    public var body: some View {
        Group {
            if isEditable {
                TextField(
                    "",
                    text: $description,
                    prompt: Text(placeholder).foregroundStyle(
                        placeholderStyle
                    ),
                    axis: isExpandable ? .vertical : .horizontal
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .onChange(of: description) { _, newValue in
                    if newValue.count > characterLimit {
                        description = String(newValue.prefix(characterLimit))
                    }
                    
                    debounceTask?.cancel()
                    debounceTask = Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(500))
                        guard !Task.isCancelled else { return }
                        onEditingEnded()
                    }
                }
                .onDisappear {
                    debounceTask?.cancel()
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
        .font(font)
        .foregroundStyle(foregroundStyle)
    }
}
