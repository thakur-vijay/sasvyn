//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 22/08/26.
//

import SwiftUI
import ComposableArchitecture

enum GridType: String {
    case two = "square.grid.2x2.fill"
    case three = "rectangle.grid.3x2.fill"
    
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
}

public struct ScreenshotsReorderView: View {
    let store: StoreOf<ScreenshotsReorderFeature>
    
    public init(store: StoreOf<ScreenshotsReorderFeature>) {
        self.store = store
    }
    
    @State private var draggingItem: ProjectScreenshot?
    
    @State private var screenshotSize: CGSize = .zero
    @State private var gridType: GridType = .two
    
    @Namespace
    private var animation
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: gridType.count), spacing: 10) {
                    ForEach(store.screenshots) { screenshot in
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.pink.gradient)
                            .aspectRatio(428.0 / 926.0, contentMode: .fill)
                            .onGeometryChange(for: CGSize.self, of: { proxy in
                                return proxy.size
                            }, action: { newValue in
                                screenshotSize = newValue
                            })
                            .matchedGeometryEffect(id: screenshot.id, in: animation)
                            .opacity(draggingItem?.id == screenshot.id ? 0 : 1)
                            .draggable(screenshot) {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.pink.gradient)
                                    .frame(width: screenshotSize.width, height: screenshotSize.height)
                                    .onAppear {
                                        draggingItem = screenshot
                                    }
                            }
                            .dropDestination(for: ProjectScreenshot.self) { items, location in
                                return false
                            } isTargeted: { status in
                                guard let draggingItem, status, draggingItem.id != screenshot.id else { return }
                                guard let sourceIndex = store.screenshots.firstIndex(where: { $0.id == draggingItem.id }) else { return }
                                guard let destinationIndex = store.screenshots.firstIndex(where: { $0.id == screenshot.id })
                                else { return }
                                
                                withAnimation(.bouncy) {
                                    store.send(.reorder(sourceIndex, destinationIndex))
                                }
                            }

                    }
                }
                .padding(20)
            }
            .navigationTitle("Edit Screenshots")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: gridType.next.rawValue){
                        switch gridType {
                        case .two: gridType = .three
                        case .three: gridType = .two
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark"){
                        
                    }
                }
            }
            .animation(.smooth, value: gridType)
        }
    }
}
