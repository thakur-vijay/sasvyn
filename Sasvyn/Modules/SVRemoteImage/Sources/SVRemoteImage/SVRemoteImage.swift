//
//  File.swift
//  SVRemoteImage
//
//  Created by Vijay Thakur on 11/08/26.
//

import Nuke
import NukeUI
import SwiftUI

public struct SVRemoteImage<S: Shape, Placeholder: View>: View {

    private let url: URL?

    private let size: CGSize

    private let shape: S

    private let placeholder: Placeholder

    @Environment(\.displayScale)

    private var displayScale

    public init(

        url: URL?,

        size: CGSize,

        shape: S,

        @ViewBuilder placeholder: () -> Placeholder

    ) {

        self.url = url

        self.size = size

        self.shape = shape

        self.placeholder = placeholder()

    }

    public init(

        url: URL?,

        side: CGFloat,

        shape: S,

        @ViewBuilder placeholder: () -> Placeholder

    ) {

        self.init(

            url: url,

            size: .init(width: side, height: side),

            shape: shape,

            placeholder: placeholder

        )

    }

    public var body: some View {

        LazyImage(

            request: ImageRequest(

                url: url,

                processors: [

                    ImageProcessors.Resize(

                        size: size.scaled(by: displayScale),

                        contentMode: .aspectFill

                    )

                ]

            )

        ) { state in

            if let image = state.image {

                image

                    .resizable()

                    .scaledToFill()

            } else {

                placeholder

            }

        }

        .frame(width: size.width, height: size.height)

        .clipped()

        .clipShape(shape)

    }

}

public extension SVRemoteImage where Placeholder == Color {

    init(
        url: URL?,
        size: CGSize,
        shape: S
    ) {
        self.init(
            url: url,
            size: size,
            shape: shape
        ) {
            Color.secondary.opacity(0.2)
        }
    }

    init(
        url: URL?,
        side: CGFloat,
        shape: S
    ) {
        self.init(
            url: url,
            side: side,
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
