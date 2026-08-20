//
//  File.swift
//  SVRemoteImage
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI

public struct SVRemoteImage<S: Shape, Placeholder: View & Sendable>: View {

    private let url: URL?
    private let size: CGSize
    private let contentMode: ContentMode
    private let shape: S
    private let placeholder: Placeholder

    @Environment(\.displayScale) private var displayScale

    nonisolated public init(
        url: URL?,
        size: CGSize,
        contentMode: ContentMode,
        shape: S,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.url = url
        self.size = size
        self.shape = shape
        self.contentMode = contentMode
        self.placeholder = placeholder()
    }

    nonisolated public init(
        url: URL?,
        side: CGFloat,
        contentMode: ContentMode,
        shape: S,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.init(
            url: url,
            size: .init(width: side, height: side),
            contentMode: contentMode,
            shape: shape,
            placeholder: placeholder
        )
    }

    public var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            placeholder
        }
        .frame(width: size.width, height: size.height)
        .clipShape(shape)
    }

}

public extension SVRemoteImage where Placeholder == Color {

    init(
        url: URL?,
        size: CGSize,
        contentMode: ContentMode = .fill,
        shape: S,
    ) {
        self.init(
            url: url,
            size: size,
            contentMode: contentMode,
            shape: shape
        ) {
            Color.secondary.opacity(0.2)
        }
    }

   nonisolated init(
        url: URL?,
        side: CGFloat,
        contentMode: ContentMode = .fill,
        shape: S
    ) {
        self.init(
            url: url,
            side: side,
            contentMode: contentMode,
            shape: shape
        ) {
            Color.secondary.opacity(0.2)
        }
    }
}

public extension CGSize {

    func scaled(

        by scale: CGFloat

    ) -> CGSize {

        CGSize(

            width: width * scale,

            height: height * scale

        )

    }

}
