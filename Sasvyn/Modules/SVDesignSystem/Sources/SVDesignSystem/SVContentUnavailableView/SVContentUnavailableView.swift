//
//  SVContentUnavailableView.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI

public struct SVContentUnavailableView<Actions: View>: View {

    private let title: String
    private let description: String
    private let systemImage: String
    private let actions: Actions

    public init(
        title: String,
        systemImage: String,
        description: String,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
        self.actions = actions()
    }

    public var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(Color.accentColor)
            }

        } description: {
            Text(description)
        } actions: {
            actions
        }
    }
}

public extension SVContentUnavailableView where Actions == EmptyView {

    init(
        title: String,
        systemImage: String,
        description: String
    ) {
        self.init(
            title: title,
            systemImage: systemImage,
            description: description
        ) {
            EmptyView()
        }
    }
}
