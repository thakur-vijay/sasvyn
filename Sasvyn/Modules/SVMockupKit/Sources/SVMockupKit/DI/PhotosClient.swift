//
//  PhotosClient.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 03/09/26.
//


import ComposableArchitecture

#if os(iOS)
import Photos
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct PhotosClient: Sendable {

    public var saveImage:
        @Sendable (_ url: URL) async throws -> Void

    public init(
        saveImage: @escaping @Sendable (_ url: URL) async throws -> Void
    ) {
        self.saveImage = saveImage
    }
}

extension PhotosClient: DependencyKey {

    public static let liveValue = Self(
        saveImage: { url in

            #if os(iOS)

            guard let image = UIImage(contentsOfFile: url.path) else {
                throw PhotosClientError.invalidImage
            }

            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }

            #elseif os(macOS)

            guard NSImage(contentsOfFile: url.path) != nil else {
                throw PhotosClientError.invalidImage
            }

            // Photos framework / PHPhotoLibrary is not available on macOS.
            // macOS implementation will be added later.

            throw PhotosClientError.unsupportedPlatform

            #endif
        }
    )
}

extension PhotosClient: TestDependencyKey {

    public static let testValue = Self(
        saveImage: { _ in }
    )
}

public extension DependencyValues {

    var photosClient: PhotosClient {
        get { self[PhotosClient.self] }
        set { self[PhotosClient.self] = newValue }
    }
}

public enum PhotosClientError: Error {
    case invalidImage
    case unsupportedPlatform
}
