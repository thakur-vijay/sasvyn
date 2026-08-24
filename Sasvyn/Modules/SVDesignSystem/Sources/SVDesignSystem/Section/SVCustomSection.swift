//
//  SVSection.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI

public struct SVSection<Content: View, Trailing: View>: View {
    private let title: String
    private let footer: String?
    private let content: Content
    private let trailing: Trailing
    private let titleHorizontalPadding: CGFloat
    
    public init(
        title: String,
        titleHorizontalPadding: CGFloat = 0,
        footer: String? = nil,
        @ViewBuilder content: @escaping ()-> Content,
        @ViewBuilder trailing: @escaping ()-> Trailing,
    ) {
        self.title = title
        self.titleHorizontalPadding = titleHorizontalPadding
        self.footer = footer
        self.content = content()
        self.trailing = trailing()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                trailing
            }
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

public extension SVSection where Trailing == EmptyView {
    
    init(
        title: String,
        titleHorizontalPadding: CGFloat = 0,
        footer: String? = nil,
        @ViewBuilder content: @escaping ()-> Content,
    ) {
        self.init(
            title: title,
            titleHorizontalPadding: titleHorizontalPadding,
            footer: footer,
            content: content) {
                EmptyView()
            }
    }
}
