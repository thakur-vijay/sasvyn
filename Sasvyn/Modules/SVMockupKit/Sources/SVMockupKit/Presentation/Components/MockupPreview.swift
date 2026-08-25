//
//  MockupRenderMode.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import SwiftUI
import ImageIO
import UIKit

public struct MockupPreview: View {

    @Environment(\.displayScale) private var displayScale

    private let imageData: Data?
    private let scaleResize: ImageScaleResize
    private let selectedDevice: Device
    private let renderMode: MockupRenderMode
    private let action: () -> Void

    public init(
        imageData: Data?,
        scaleResize: ImageScaleResize,
        selectedDevice: Device,
        renderMode: MockupRenderMode,
        action: @escaping () -> Void
    ) {
        self.imageData = imageData
        self.scaleResize = scaleResize
        self.selectedDevice = selectedDevice
        self.renderMode = renderMode
        self.action = action
    }

    public var body: some View {
        Group {
            if let deviceImage = selectedDevice.uiImage{
                content(
                    deviceImage: deviceImage,
                    screenImage: selectedDevice.screenUIImage,
                    screenRadius: selectedDevice.screenRadius
                )
                .aspectRatio(
                    deviceImage.size.width / deviceImage.size.height,
                    contentMode: .fit
                )
            }
        }
    }

    @ViewBuilder
    private func content(
        deviceImage: UIImage,
        screenImage: UIImage?,
        screenRadius: CGFloat?
    ) -> some View {

        switch renderMode {

        case .preview:

            GeometryReader { proxy in
                mockupContent(
                    deviceImage: deviceImage,
                    screenImage: screenImage,
                    screenRadius: screenRadius,
                    canvasSize: proxy.size,
                    pixelScale: displayScale
                )
            }

        case .export(let size):

            mockupContent(
                deviceImage: deviceImage,
                screenImage: screenImage,
                screenRadius: screenRadius,
                canvasSize: size,
                pixelScale: 1
            )
            .frame(
                width: size.width,
                height: size.height
            )
        }
    }

    @ViewBuilder
    private func mockupContent(
        deviceImage: UIImage,
        screenImage: UIImage?,
        screenRadius: CGFloat?,
        canvasSize: CGSize,
        pixelScale: CGFloat
    ) -> some View {

        let deviceWidth = deviceImage.size.width
        let deviceHeight = deviceImage.size.height

        let screenWidthRatio =
            selectedDevice.screenSize.width / deviceWidth

        let screenHeightRatio =
            selectedDevice.screenSize.height / deviceHeight

        let targetSize = CGSize(
            width: canvasSize.width * screenWidthRatio,
            height: canvasSize.height * screenHeightRatio
        )

        let targetPixelSize = CGSize(
            width: targetSize.width * pixelScale,
            height: targetSize.height * pixelScale
        )

        ZStack {

            if let imageData,
               let image = downsample(
                    imageData,
                    to: targetPixelSize
               ) {

                Image(uiImage: image)
                    .resizable()
                    .scaledTo(scaleResize)
                    .frame(
                        width: targetSize.width,
                        height: targetSize.height
                    )
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: screenRadius ?? 0, style: .continuous))
                    .optionalMask(screenImage != nil){
                        if let screenImage{
                            Image(uiImage: screenImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: targetSize.width,
                                    height: targetSize.height
                                )
                        }
                    }
            }else {
                Image(uiImage: deviceImage)
                    .resizable()
                    .scaledToFit()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        action()
                    }
            }
            Image(uiImage: deviceImage)
                .resizable()
                .scaledToFit()
                .contentShape(Rectangle())
                .onTapGesture {
                    action()
                }
        }
    }

    private func downsample(
        _ data: Data,
        to targetPixelSize: CGSize
    ) -> UIImage? {

        guard
            targetPixelSize.width > 0,
            targetPixelSize.height > 0
        else {
            return nil
        }

        let sourceOptions: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]

        guard let source = CGImageSourceCreateWithData(
            data as CFData,
            sourceOptions as CFDictionary
        ) else {
            return nil
        }

        let properties = CGImageSourceCopyPropertiesAtIndex(
            source,
            0,
            nil
        ) as? [CFString: Any]

        let sourceWidth =
            (properties?[kCGImagePropertyPixelWidth] as? NSNumber)?
            .intValue ?? 0

        let sourceHeight =
            (properties?[kCGImagePropertyPixelHeight] as? NSNumber)?
            .intValue ?? 0

        guard sourceWidth > 0, sourceHeight > 0 else {
            return nil
        }

        let maxPixelSize = Int(
            ceil(
                max(
                    targetPixelSize.width,
                    targetPixelSize.height
                )
            )
        )

        // Don't downsample when the source is already
        // smaller than or equal to the required resolution.
        let sourceMaxPixelSize = max(
            sourceWidth,
            sourceHeight
        )

        if sourceMaxPixelSize <= maxPixelSize {

            let imageOptions: [CFString: Any] = [
                kCGImageSourceShouldCache: true
            ]

            guard let cgImage = CGImageSourceCreateImageAtIndex(
                source,
                0,
                imageOptions as CFDictionary
            ) else {
                return nil
            }

            return UIImage(
                cgImage: cgImage,
                scale: 1,
                orientation: .up
            )
        }

        let thumbnailOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceShouldCache: false,
            kCGImageSourceShouldCacheImmediately: false
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            thumbnailOptions as CFDictionary
        ) else {
            return nil
        }

        return UIImage(
            cgImage: cgImage,
            scale: 1,
            orientation: .up
        )
    }
}

public enum ImageScaleResize: Sendable{
    case fit
    case fill
    
    public var symbol: String {
        switch self {
        case .fit: "arrow.down.right.and.arrow.up.left"
        case .fill: "arrow.up.left.and.arrow.down.right"
        }
    }
    
    public var next: Self {
        switch self {
        case .fit: .fill
        case .fill: .fit
        }
    }
}
fileprivate extension View {
    @ViewBuilder
    func scaledTo(_ scale: ImageScaleResize)-> some View {
        switch scale {
        case .fit:
            self.scaledToFit()
        case .fill:
            self.scaledToFill()
        }
    }
    
    @ViewBuilder
    func optionalMask<Content: View>(_ isActive: Bool, @ContentBuilder mask: @escaping ()-> Content)-> some View {
        if isActive {
            self
                .mask {
                    mask()
                }
        }else {
            self
        }
    }
}
