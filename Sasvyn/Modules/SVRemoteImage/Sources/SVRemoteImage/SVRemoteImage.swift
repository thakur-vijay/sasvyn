//
//  File.swift
//  SVRemoteImage
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import Nuke
import NukeUI

public enum Cache: Sendable {
    case enabled
    case disabled

    var options: ImageRequest.Options {
        switch self {
        case .enabled:
            return []

        case .disabled:
            return [
                .disableMemoryCacheReads,
                .disableMemoryCacheWrites,
                .disableDiskCacheReads,
                .disableDiskCacheWrites,
                .disableDiskCache,
                .disableMemoryCache,
            ]
        }
    }
}

public struct SVRemoteImage<S: Shape, Placeholder: View & Sendable>: View {

    private let url: URL?
    private let size: CGSize?
    private let aspectRatio: CGFloat?
    private let contentMode: ContentMode
    private let shape: S
    private let cache: Cache
    private let placeholder: Placeholder

    @Environment(\.displayScale) private var displayScale

    nonisolated public init(
        url: URL?,
        size: CGSize?,
        aspectRatio: CGFloat?,
        contentMode: ContentMode,
        shape: S,
        cache: Cache = .enabled,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.url = url
        self.size = size
        self.aspectRatio = aspectRatio
        self.shape = shape
        self.contentMode = contentMode
        self.cache = cache
        self.placeholder = placeholder()
    }

    public var body: some View {
        LazyImage(
            request: ImageRequest(
                url: url,
                processors: [
                    ImageProcessors.Resize(
                        size: size?.scaled(by: displayScale) ?? .zero,
                        contentMode: .aspectFill
                    )
                ],
                options: cache.options
            )
        ) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: contentMode)
            } else {
                placeholder
            }
        }
        .frame(width: size?.width, height: size?.height)
        .aspectRatio(aspectRatio, contentMode: contentMode)
        .clipShape(shape)
        .task {
            print(cache.options)
        }
        
    }

}

public extension SVRemoteImage where Placeholder == Color {

    init(
        url: URL?,
        size: CGSize,
        contentMode: ContentMode = .fill,
        shape: S,
        cache: Cache = .enabled
    ) {
        self.init(
            url: url,
            size: size,
            aspectRatio: nil,
            contentMode: contentMode,
            shape: shape,
            cache: cache
        ) {
            Color.secondary.opacity(0.2)
        }
    }
    
    init(
        url: URL?,
        aspectRatio: CGFloat,
        contentMode: ContentMode = .fill,
        shape: S,
        cache: Cache = .enabled
    ) {
        self.init(
            url: url,
            size: nil,
            aspectRatio: aspectRatio,
            contentMode: contentMode,
            shape: shape,
            cache: cache
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
