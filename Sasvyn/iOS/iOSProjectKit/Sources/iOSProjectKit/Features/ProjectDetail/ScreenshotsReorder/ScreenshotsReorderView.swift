//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 22/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import SVProjectKit
import SVDesignSystem

enum GridType {
    case two
    case three
    
    var count: Int {
        switch self {
        case .two: 2
        case .three: 3
        }
    }
    
    var next: Self {
        switch self {
        case .two: .three
        case .three: .two
        }
    }
    
    var symbol: SVSymbol {
        switch self {
        case .two: SVSymbols.grid2x2
        case .three: SVSymbols.grid3x2
        }
    }
}

public struct ScreenshotsReorderView: View {
    let store: StoreOf<ScreenshotsReorderFeature>
    
    public init(store: StoreOf<ScreenshotsReorderFeature>) {
        self.store = store
    }
    
    @State private var draggingItem: ProjectScreenshot.ID?
    
    @State private var screenshotSize: CGSize = .zero
    @State private var gridType: GridType = .two
    @State private var scrollPhase: ScrollPhase = .idle
    
    @Namespace
    private var animation
    
    public var body: some View {
        NavigationStack {
            GeometryReader{
                let screenSize = $0.size
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 2), count: gridType.count), spacing: 2) {
                        ForEach(store.screenshots) { screenshot in
                            let width = (screenSize.width - 20) / CGFloat(gridType.count)
                            let height = width / screenshot.aspectRatio
                            SVRemoteImage(
                                url: screenshot.imageURL,
                                size: .init(width: width, height: height),
                                contentMode: .fit,
                                shape: .rect,
                                cache: .disabled
                            )
                            .draggable(screenshot.id){
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 1, height: 1)
                                    .onAppear {
                                        draggingItem = screenshot.id
                                    }
                            }
                            .dropDestination(for: ProjectScreenshot.ID.self) { items, location in
                                self.draggingItem = nil
                                return false
                            } isTargeted: { status in
                                guard let draggingItem, status, draggingItem != screenshot.id else { return }
                                guard let sourceIndex = store.screenshots.firstIndex(where: { $0.id == draggingItem }) else { return }
                                guard let destinationIndex = store.screenshots.firstIndex(where: { $0.id == screenshot.id })
                                else { return }

                                _ = withAnimation(.bouncy) {
                                    store.send(.reorder(sourceIndex, destinationIndex))
                                }
                            }
                        }
                    }
                    .padding(10)
                }
                .onScrollPhaseChange { old, new in
                    self.scrollPhase = new
                }
            }
            .navigationTitle("Edit Screenshots")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
                
                SVToolbarItem(symbol: gridType.next.symbol, placement: .topBarTrailing){
                    if self.scrollPhase == .idle {
                        switch gridType {
                        case .two: gridType = .three
                        case .three: gridType = .two
                        }
                    }
                }
                
                SVToolbarItem.check {
                    store.send(.checkTapped)
                }
            }
            .animation(.smooth, value: gridType)
        }
    }
}
