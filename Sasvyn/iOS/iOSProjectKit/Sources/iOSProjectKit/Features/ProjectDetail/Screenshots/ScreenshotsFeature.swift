//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI
import ImageIO
import UniformTypeIdentifiers


@Reducer
public struct ScreenshotsFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var mode: ProjectMode
        public var screenshots: [ProjectScreenshot]
        public var isPhotosPickerPresented: Bool = false
        public var selectedImages: [PhotosPickerItem] = []

        public init(mode: ProjectMode) {
            self.mode = mode
            self.screenshots = (1...20).map { index in
                ProjectScreenshot(order: index)
            }
        }
        
        
        @Presents
        var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case modeChanged(ProjectMode)
        case screenshotTapped(ProjectScreenshot)
        case updateScreenshots
        case screenshotProcessed(UUID, URL)
        case reorderTapped
    }
    
    public init(){}
    
    @Reducer
    public enum Destination {
        case screenshotsReorder(ScreenshotsReorderFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            case .binding(_):
                return .none
            case .screenshotTapped:
                state.isPhotosPickerPresented.toggle()
                return .none
            case .updateScreenshots:
                let selectedImages = state.selectedImages
                state.selectedImages.removeAll()
                
                let targets = zip(
                    selectedImages,
                    state.screenshots
                        .filter { $0.imageURL == nil }
                        .prefix(selectedImages.count)
                        .map(\.id)
                )

                return .run { send in
                    await withTaskGroup(of: Void.self) { group in
                        for (item, screenshotID) in targets {
                            group.addTask {
                                do {
                                    guard let data = try await item.loadTransferable(
                                        type: Data.self
                                    ) else {
                                        return
                                    }

                                    let url = try ScreenshotSaver.saveScreenshot(data)

                                    await send(
                                        .screenshotProcessed(
                                            screenshotID,
                                            url
                                        )
                                    )
                                } catch {
                                    // handle error
                                }
                            }
                        }
                    }
                }
            case .screenshotProcessed(let id, let url):
                guard let index = state.screenshots.firstIndex(where: {
                    $0.id == id
                }) else {
                    return .none
                }

                state.screenshots[index].imageURL = url

                return .none
            case .reorderTapped:
                state.destination = .screenshotsReorder(.init())
                return .none
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

enum ScreenshotSaver {
    static func saveScreenshot(_ data: Data) throws -> URL {
        let sourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let source = CGImageSourceCreateWithData(
            data as CFData,
            sourceOptions
        ) else {
            throw ScreenshotError.invalidImage
        }

        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 2048,
            kCGImageSourceShouldCacheImmediately: false
        ] as CFDictionary

        guard let image = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            options
        ) else {
            throw ScreenshotError.invalidImage
        }

        let directory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent("ProjectScreenshots", isDirectory: true)

        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        let url = directory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("jpg")

        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.jpeg.identifier as CFString,
            1,
            nil
        ) else {
            throw ScreenshotError.invalidImage
        }

        CGImageDestinationAddImage(
            destination,
            image,
            [
                kCGImageDestinationLossyCompressionQuality: 0.85
            ] as CFDictionary
        )

        guard CGImageDestinationFinalize(destination) else {
            throw ScreenshotError.invalidImage
        }

        return url
    }
}

enum ScreenshotError: Error {
    case invalidImage
}

extension ScreenshotsFeature.Destination.State: Equatable {}
