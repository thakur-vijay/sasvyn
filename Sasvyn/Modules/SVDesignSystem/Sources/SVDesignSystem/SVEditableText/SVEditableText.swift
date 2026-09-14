//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI

#if os(iOS)
import UIKit
#endif

public enum SVKeyboardType {
    case `default`
    case email
    case number
    case phone
    case url

    #if os(iOS)
    var uiValue: UIKeyboardType {
        switch self {
        case .default: .default
        case .email: .emailAddress
        case .number: .numberPad
        case .phone: .phonePad
        case .url: .URL
        }
    }
    #endif
}

public enum SVTextContentType {
    case name
    case emailAddress
    case telephoneNumber
    case username
    case password
    case URL

    #if os(iOS)
    var uiValue: UITextContentType {
        switch self {
        case .name: .name
        case .emailAddress: .emailAddress
        case .telephoneNumber: .telephoneNumber
        case .username: .username
        case .password: .password
        case .URL: .URL
        }
    }
    #endif
}

@available(iOS 18.0, macOS 15.0, *)
public struct SVEditableText: View {

    @Binding private var description: String

    private let placeholder: String
    private let isExpandable: Bool
    private let collapsedLineLimit: Int
    private let characterLimit: Int
    private let isEditable: Bool
    private let font: Font
    private let placeholderStyle: Color
    private let foregroundStyle: Color
    private let keyboardType: SVKeyboardType
    private let contentType: SVTextContentType
    private let onEditingEnded: () -> Void

    @State private var debounceTask: Task<Void, Never>?

    public init(
        description: Binding<String>,
        placeholder: String,
        isExpandable: Bool = true,
        collapsedLineLimit: Int = 2,
        characterLimit: Int,
        isEditable: Bool = false,
        font: Font = .caption,
        placeholderStyle: Color = .secondary,
        foregroundStyle: Color = .primary,
        keyboardType: SVKeyboardType = .default,
        contentType: SVTextContentType = .name,
        onEditingEnded: @escaping () -> Void
    ) {
        self._description = description
        self.placeholder = placeholder
        self.isExpandable = isExpandable
        self.collapsedLineLimit = collapsedLineLimit
        self.characterLimit = characterLimit
        self.isEditable = isEditable
        self.font = font
        self.placeholderStyle = placeholderStyle
        self.foregroundStyle = foregroundStyle
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.onEditingEnded = onEditingEnded
    }

    public var body: some View {
        Group {
            if isEditable {
                editableText
            } else {
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

    private var editableText: some View {
        TextField(
            "",
            text: $description,
            prompt: Text(placeholder)
                .foregroundStyle(placeholderStyle),
            axis: isExpandable ? .vertical : .horizontal
        )
        .autocorrectionDisabled()
        #if os(iOS)
        .keyboardType(keyboardType.uiValue)
        .textContentType(contentType.uiValue)
        .textInputAutocapitalization(.never)
        #endif
        .onChange(of: description) { _, newValue in
            if newValue.count > characterLimit {
                description = String(newValue.prefix(characterLimit))
            }

            debounceTask?.cancel()

            debounceTask = Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(500))

                guard !Task.isCancelled else {
                    return
                }

                onEditingEnded()
            }
        }
        .onDisappear {
            debounceTask?.cancel()
        }
    }
}
