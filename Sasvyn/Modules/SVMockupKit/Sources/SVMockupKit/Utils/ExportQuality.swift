//
//  ExportQuality.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//


import SwiftUI
import UIKit
import UniformTypeIdentifiers

@available(iOS 18.0, *)
public enum ExportQuality: String, CaseIterable {
    case hd = "HD"
    case fullHD = "Full HD"
    case twoK = "2K"
    case fourK = "4K"
    case sixK = "6K"
    case eightK = "8K"

    var longSide: CGFloat {
        switch self {
        case .hd:
            return 1280

        case .fullHD:
            return 1920

        case .twoK:
            return 2560

        case .fourK:
            return 3840

        case .sixK:
            return 6144

        case .eightK:
            return 7680
        }
    }
}

@available(iOS 18.0, *)
extension ExportQuality {

    public func size(
        preserving aspectRatio: CGFloat
    ) -> CGSize {

        guard aspectRatio > 0 else {
            return .zero
        }

        if aspectRatio >= 1 {
            return CGSize(
                width: longSide,
                height: longSide / aspectRatio
            )
        } else {
            return CGSize(
                width: longSide * aspectRatio,
                height: longSide
            )
        }
    }
}

@available(iOS 18.0, *)
public enum Exporter {

    @MainActor
    public static func renderMockup(
        imageData: Data?,
        scaleResize: ImageScaleResize,
        device: Device,
        quality: ExportQuality,
        action: @escaping () -> Void = {}
    ) -> Data? {

        guard let deviceImage = device.uiImage else {
            return nil
        }

        let aspectRatio =
            deviceImage.size.width /
            deviceImage.size.height

        let exportSize = quality.size(
            preserving: aspectRatio
        )

        let view = MockupPreview(
            imageData: imageData,
            scaleResize: scaleResize,
            selectedDevice: device,
            renderMode: .export(exportSize),
            action: action
        )

        let renderer = ImageRenderer(
            content: view
        )

        renderer.scale = 1
        renderer.isOpaque = false
        renderer.colorMode = .nonLinear

        return renderer.uiImage?.pngData()
    }
    
    public static func downsample(
        imageData: Data,
        maxPixelSize: CGFloat
    ) -> Data? {
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return nil
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceShouldCacheImmediately: false
        ]

        guard let image = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            options as CFDictionary
        ) else {
            return nil
        }

        let output = NSMutableData()

        guard let destination = CGImageDestinationCreateWithData(
            output,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            return nil
        }

        CGImageDestinationAddImage(destination, image, nil)

        guard CGImageDestinationFinalize(destination) else {
            return nil
        }

        return output as Data
    }
}
