//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage

public struct iOSMockupsView: View {
    let mode: MockupsPresentationMode
    @Bindable var store: StoreOf<iOSMockupsFeature>
    
    public init(store: StoreOf<iOSMockupsFeature>, mode: MockupsPresentationMode = .full) {
        self.store = store
        self.mode = mode
    }
    
    @AppStorage("imageContentMode") private var imageContentMode: ImageContentMode = .fill
    @Namespace private var animation
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 1, alignment: .top), count: 4), spacing: 1) {
                ForEach(store.mockups) { mockup in
                    GeometryReader {
                        SVRemoteImage(url: mockup.thumbnail, size: $0.size, shape: .rect)
                    }
                    .aspectRatio(imageContentMode == .fit ? mockup.aspectRatio : 1, contentMode: .fit)
                    .matchedGeometryEffect(id: mockup.id, in: animation)
                    .contextMenu {
                        Button("Save to Photos", systemImage: "photo") {
                            
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            store.send(.deleteTapped(mockup))
                        }
                    } preview: {
                        SVRemoteImage(
                            url: mockup.url,
                            size: .init(width: 300, height: 600),
                            contentMode: .fit,
                            shape: .rect,
                            cache: .disabled
                        )
                    }
                }
            }
            .padding(imageContentMode.padding)
        }
        .animation(.snappy(duration: 0.25), value: imageContentMode)
        .overlay {
            if store.mockups.isEmpty {
                ContentUnavailableView(
                    "No Mockups",
                    systemImage: "iphone",
                    description: Text("Create your first mockup to see it here.")
                )
            }
        }
        .navigationTitle("Mockups")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if mode == .picker{
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        store.send(.addTapped)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    store.send(.addTapped)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "rectangle.expand.vertical") {
                    if imageContentMode == .fit {
                        imageContentMode = .fill
                    }else {
                        imageContentMode = .fit
                    }
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .iOSCreateMockup(let store):
                iOSCreateMockupView(store: store)
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
    }
}
