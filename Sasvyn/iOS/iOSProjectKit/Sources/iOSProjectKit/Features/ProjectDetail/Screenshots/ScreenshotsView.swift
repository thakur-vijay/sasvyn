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
import iOSMockupKit
import SVMockupKit
import SVProjectKit

struct ScreenshotsView: View {
    let screenSize: CGSize
    @Bindable var store: StoreOf<ScreenshotsFeature>
    
    init(screenSize: CGSize, store: StoreOf<ScreenshotsFeature>) {
        self.screenSize = screenSize
        self.store = store
    }
    
    private var screenshotWidth: CGFloat {
        screenSize.width * 0.68
    }
    
    private var screenshotHeight: CGFloat {
        guard let minimumAspectRatio = store.screenshots
            .map(\.aspectRatio)
            .min(),
                minimumAspectRatio > 0
        else {
            return 0
        }
        return screenshotWidth / minimumAspectRatio
    }
    
    @State private var scrollPosition: ScrollPosition = .init()
    var body: some View {
        SVSection(title: "Preview", titleHorizontalPadding: SVSpacing.screenHorizontal) {
            if store.screenshots.isEmpty {
                SVContentUnavailableView(
                    title: "No Screenshots Yet",
                    systemImage: "photo.on.rectangle.angled",
                    description: "Add screenshots to preview your project here."
                ) {
                    SVButton(
                        "Add Screenshots",
                        systemImage: "plus",
                        size: .medium,
                        width: .intrinsic) {
                            store.send(.addPreviewsTapped)
                        }
                }
            }else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(store.screenshots) { screenshot in
                            let width = screenshotWidth
                            let height = width / screenshot.aspectRatio
                            SVRemoteImage(
                                url: screenshot.imageURL,
                                size: .init(
                                    width: width,
                                    height: height
                                ),
                                contentMode: .fit,
                                shape: .rect,
                                cache: store.mode.isEditable ? .disabled : .enabled
                            )
                            .task {
                                print("ORDER", screenshot.order)
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                store.send(.screenshotTapped(screenshot))
                            }
                            .optionalContextMenu(
                                store.mode.isEditable,
                                isPreviewHidden: true) {
                                    Button("Delete", systemImage: "trash") {
                                        store.send(.deleteScreenshotTapped(screenshot))
                                    }
                                } preview: {
                                    
                                }
                            
                        }
                        
                        if let last = store.screenshots.last, store.screenshots.count < ProjectConfiguration.Media.screenshotsLimit, store.mode.isEditable{
                            if let device = Devices.all.first(where: {$0.assetName == last.device}), let uiImage = device.uiImage{
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: screenshotWidth, height: screenshotWidth / (last.aspectRatio))
                                    .overlay {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                    }
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        store.send(.addPreviewsTapped)
                                    }
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, SVSpacing.screenHorizontal + 10)
                }
                .frame(height: screenshotHeight)
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition($scrollPosition, anchor: .center)
            }
        } trailing: {
            if store.screenshots.count > 1 && store.mode.isEditable{
                Button("Reorder"){
                    store.send(.reorderTapped)
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .screenshotsReorder(let store):
                ScreenshotsReorderView(store: store)
                    .interactiveDismissDisabled()
            case .mockupsPicker(let store):
                iOSMockupsView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .imageViewer(item: $store.selectedScreenshot, items: store.screenshots) { scrollPosition in
            self.scrollPosition = scrollPosition
        }
    }
}
