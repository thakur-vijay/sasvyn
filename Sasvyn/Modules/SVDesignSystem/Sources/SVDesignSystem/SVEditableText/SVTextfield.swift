//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 29/08/26.
//

import SwiftUI

public struct SVTextfield: View {
    let placeholder: String
    @Binding var value: String
    
    public init(placeholder: String, value: Binding<String>) {
        self.placeholder = placeholder
        self._value = value
    }
    
    public var body: some View {
        TextField(
            "",
            text: $value,
            prompt: Text(placeholder)
                .foregroundStyle(
                    .placeholder
                )
        )
        .font(.callout)
        .foregroundStyle(.primary)
    }
}
