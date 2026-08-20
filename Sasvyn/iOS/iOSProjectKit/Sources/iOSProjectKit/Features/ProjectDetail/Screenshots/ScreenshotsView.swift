//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import SVDesignSystem
import PhotosUI

struct ScreenshotsView: View {
    let screenSize: CGSize
    @Bindable var store: StoreOf<ScreenshotsFeature>
    
    init(screenSize: CGSize, store: StoreOf<ScreenshotsFeature>) {
        self.screenSize = screenSize
        self.store = store
    }
    
    var body: some View {
        SVSection(title: "Preview", titleHorizontalPadding: SVSpacing.screenHorizontal) {
            let screenshotWidth = screenSize.width * 0.6
            let screenshotHeight = screenshotWidth * 19.5 / 9
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(store.screenshots) { screenshot in
                        ScreenshotView(
                            screenshot: screenshot,
                            size: .init(
                                width: screenshotWidth,
                                height: screenshotHeight
                            )
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            store.send(.screenshotTapped(screenshot))
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, SVSpacing.screenHorizontal)
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
        }
        .photosPicker(isPresented: $store.isPhotosPickerPresented, selection: $store.selectedImages, maxSelectionCount: store.screenshots.filter { $0.imageURL == nil }.count)
        .onChange(of: store.isPhotosPickerPresented) { oldValue, newValue in
            if !newValue && !store.selectedImages.isEmpty {
                store.send(.updateScreenshots)
            }
        }
    }
}
