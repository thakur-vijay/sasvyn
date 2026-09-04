//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 26/08/26.
//

import SwiftUI
import SVRemoteImage

public extension View {
    @ViewBuilder
    func imageViewer<Item: ImageViewerItem>(
        item: Binding<Item?>,
        items: [Item],
        onScrollPositionChange: @escaping (ScrollPosition)-> Void = { _ in }
    ) -> some View {
        self
            .sheet(item: item) { value in
                ImageViewer(
                    items: items,
                    selection: value,
                    onScrollPositionChange: onScrollPositionChange
                ) {
                    item.wrappedValue = nil
                }
                .interactiveDismissDisabled()
            }
    }
}


internal struct ImageViewer<Item: ImageViewerItem>: View {
    let items: [Item]
    let selection: Item
    let onScrollPositionChange: (ScrollPosition)->()
    let onClose: ()->()

    @State private var scrollPosition: ScrollPosition = .init()
    var body: some View {
        NavigationStack {
            GeometryReader{ reader in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(items) { item in
                            let width = reader.size.width * 0.8
                            let height = width / item.aspectRatio
                            SVRemoteImage(
                                url: item.imageURL,
                                size: .init(width: width, height: height),
                                aspectRatio: nil,
                                contentMode: .fit,
                                shape: .rect,
                                cache: .disabled
                            ){}
                        }
                    }
                    .padding(.horizontal, 30)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition($scrollPosition, anchor: .center)
                .onChange(of: scrollPosition) { oldValue, newValue in
                    onScrollPositionChange(newValue)
                }
            }
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark", action: onClose)
                }
            }
        }
        .task {
            scrollPosition = .init(id: selection.id, anchor: .center)
        }
    }
}
