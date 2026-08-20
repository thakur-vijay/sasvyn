//
//  SVSection.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI

public struct SVSection<Content: View>: View {
    private let title: String
    private let footer: String?
    private let content: Content
    private let titleHorizontalPadding: CGFloat
    
    public init(
        title: String,
        titleHorizontalPadding: CGFloat = 0,
        footer: String? = nil,
        @ViewBuilder content: @escaping ()-> Content
    ) {
        self.title = title
        self.titleHorizontalPadding = titleHorizontalPadding
        self.footer = footer
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.heavy)
                .padding(.horizontal, titleHorizontalPadding)
            content
            if let footer, !footer.isEmpty{
                Text(footer)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}
