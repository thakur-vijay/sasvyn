//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import SVMockupKit
import SVDesignSystem
import SwiftUI
import UniformTypeIdentifiers

public struct iOSMockupsView: View {
    @Bindable var store: StoreOf<iOSMockupsFeature>
    
    public init(store: StoreOf<iOSMockupsFeature>) {
        self.store = store
    }
    
    @AppStorage("imageContentMode") private var imageContentMode: ImageContentMode = .fill
    @Namespace private var animation
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 1, alignment: .top), count: 4), spacing: 1) {
                ForEach(store.mockups) { mockup in
                    let isUserInteractionDisabled = (store.mode == .picker) && (store.maxSelection == store.selectedMockupIds.count) && (!store.selectedMockupIds.contains(mockup.id))
                    GeometryReader {
                        SVRemoteImage(url: mockup.thumbnail, size: $0.size, shape: .rect)
                    }
                    .aspectRatio(imageContentMode == .fit ? mockup.aspectRatio : 1, contentMode: .fit)
                    .overlay(alignment: .bottomTrailing){
                        if store.selectedMockupIds.contains(mockup.id) || (store.selection == mockup.id){
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.white, .blue)
                                .padding(12)
                        }
                    }
                    .matchedGeometryEffect(id: mockup.id, in: animation)
                    .contentShape(.rect)
                    .onTapGesture {
                        store.send(.mockupTapped(mockup))
                    }
                    .contextMenu{
                        if store.mode != .picker {
                            if let url = mockup.url, let uiImage = UIImage(contentsOfFile: url.path){
                                ShareLink(
                                    item: Image(uiImage: uiImage),
                                    preview: SharePreview("Mockup", image: Image(uiImage: uiImage))
                                ) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                            }
                            
                            Button("Save to Photos", systemImage: "photo") {
                                store.send(.saveToPhotosTapped(mockup))
                            }
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                store.send(.deleteTapped(mockup))
                            }
                        }else {
                            Button("Select", systemImage: "checkmark.circle") {
                                store.send(.mockupTapped(mockup))
                            }
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
                    .disabledWithOpacity(isUserInteractionDisabled)
                }
            }
            .padding(imageContentMode.padding)
        }
        .animation(.snappy(duration: 0.25), value: imageContentMode)
        .overlay {
            if store.mockups.isEmpty {
                SVContentUnavailableView(
                    title: "No Mockups",
                    systemImage: "iphone",
                    description: "Create your first mockup to see it here."
                )
            }
        }
        .navigationTitle("Mockups")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if store.mode == .picker{
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        store.send(.closeTapped)
                    }
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    store.send(.addTapped)
                }
                
                Button("", systemImage: "rectangle.expand.vertical") {
                    if imageContentMode == .fit {
                        imageContentMode = .fill
                    }else {
                        imageContentMode = .fit
                    }
                }
            }
            
            if store.mode == .picker && !store.isSingleSelection{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark") {
                        store.send(.checkTapped)
                    }
                    .disabledWithOpacity(store.selectedMockupIds.isEmpty)
                }
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .iOSCreateMockup(let store):
                iOSCreateMockupView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .imageViewer(item: $store.selectedMockup, items: store.mockups)
        .isASheet(store.mode == .picker)
        .task {
            await store.send(.onTask).finish()
        }
    }
    
}
