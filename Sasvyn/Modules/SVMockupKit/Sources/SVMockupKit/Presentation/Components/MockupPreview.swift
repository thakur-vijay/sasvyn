//
//  MockupRenderMode.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import SwiftUI
import ImageIO
#if os(iOS)
import UIKit
#else
import AppKit
#endif

#if os(iOS)
typealias SVImage = UIImage
#else
typealias SVImage = NSImage
#endif

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
        deviceImage: SVImage,
        screenImage: SVImage?,
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
        deviceImage: SVImage,
        screenImage: SVImage?,
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
                
                SVImageView(image: image, scaleResize: scaleResize)
                    .frame(
                        width: targetSize.width,
                        height: targetSize.height
                    )
//                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: screenRadius ?? 0, style: .continuous))
                    .optionalMask(screenImage != nil){
                        if let screenImage{
                            SVImageView(
                                image: screenImage,
                                scaleResize: .fit
                            )
                            .frame(
                                width: targetSize.width,
                                height: targetSize.height
                            )
                        }
                    }
            }else {
                SVImageView(
                    image: deviceImage,
                    scaleResize: .fill
                )
                .contentShape(.rect)
                .onTapGesture {
                    action()
                }
            }
            SVImageView(
                image: deviceImage,
                scaleResize: .fill
            )
            .contentShape(.rect)
            .onTapGesture {
                action()
            }
        }
    }
    
    private func downsample(
        _ data: Data,
        to targetPixelSize: CGSize
    ) -> SVImage? {
        
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
        
        let sourceMaxPixelSize = max(
            sourceWidth,
            sourceHeight
        )
        
        let cgImage: CGImage
        
        if sourceMaxPixelSize <= maxPixelSize {
            
            let imageOptions: [CFString: Any] = [
                kCGImageSourceShouldCache: true
            ]
            
            guard let image = CGImageSourceCreateImageAtIndex(
                source,
                0,
                imageOptions as CFDictionary
            ) else {
                return nil
            }
            
            cgImage = image
            
        } else {
            
            let thumbnailOptions: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
                kCGImageSourceShouldCache: false,
                kCGImageSourceShouldCacheImmediately: false
            ]
            
            guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(
                source,
                0,
                thumbnailOptions as CFDictionary
            ) else {
                return nil
            }
            
            cgImage = thumbnail
        }
        
#if os(iOS)
        
        return UIImage(
            cgImage: cgImage,
            scale: 1,
            orientation: .up
        )
        
#elseif os(macOS)
        
        return NSImage(
            cgImage: cgImage,
            size: NSSize(
                width: cgImage.width,
                height: cgImage.height
            )
        )
        
#endif
    }
}

internal struct SVImageView: View {

    private let image: SVImage
    private let scaleResize: ImageScaleResize

    init(
        image: SVImage,
        scaleResize: ImageScaleResize
    ) {
        self.image = image
        self.scaleResize = scaleResize
    }

    var body: some View {
        imageView
            .resizable()
            .scaledTo(scaleResize)
    }

    @ViewBuilder
    private var imageView: Image {
        #if os(iOS)
        Image(uiImage: image)
        #elseif os(macOS)
        Image(nsImage: image)
        #endif
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
