//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVMockupKit
import PhotosUI
import SVDesignSystem

public struct iOSCreateMockupView: View {
    @Bindable var store: StoreOf<iOSCreateMockupFeature>
    
    private let onDismiss: () -> Void

    public init(
        store: StoreOf<iOSCreateMockupFeature>,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.store = store
        self.onDismiss = onDismiss
    }
    
    @State private var isPhotosPickerPresented: Bool = false
    
    public var body: some View {
        let selectedDevice = store.selectedMockup?.device ?? store.selectedDevice
        NavigationStack {
            VStack(spacing: 20){
                VStack(spacing: 12) {
                    if let selectedDevice {
                        MockupPreview(
                            imageData: store.selectedMockup?.imageData,
                            scaleResize: store.selectedMockup?.imageResize ?? .fill,
                            selectedDevice: selectedDevice,
                            renderMode: .preview
                        ) {
                            if store.selectedMockup?.imageData == nil {
                                isPhotosPickerPresented.toggle()
                            }else {
                                store.send(.selectedMockupTapped)
                            }
                        }
                        .overlay {
                            if store.selectedMockup?.imageData == nil{
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(Color.accentColor)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    
                    HStack(spacing: 15) {
                        ActionButton("iphone", title: "Change Device") {
                            store.send(.changeDeviceTapped)
                        }
                        
                        ActionButton("square.on.square", title: "Apply to all") {
                            store.send(.applyToAllTapped)
                        }
                    }
                }
                .padding([.horizontal, .top], 20)
                
                if store.mockups.count > 0 {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 12) {
                            ForEach(store.mockups) { mockup in
                                MockupPreview(
                                    imageData: mockup.imageData,
                                    scaleResize: mockup.imageResize,
                                    selectedDevice: mockup.device,
                                    renderMode: .preview
                                ) {
                                    store.send(.mockupTapped(mockup))
                                }
                                .overlay {
                                    if store.selectedMockup?.id == mockup.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.headline)
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                            }
                            
                            if let device = store.selectedMockup?.device, maxSelectionCount > 0{
                                MockupPreview(
                                    imageData: nil,
                                    scaleResize: .fill,
                                    selectedDevice: device,
                                    renderMode: .preview
                                ) {
                                    isPhotosPickerPresented.toggle()
                                }
                                .overlay {
                                   Image(systemName: "plus.circle.fill")
                                        .font(.headline)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .scrollClipDisabled()
                    .frame(height: 100)
                    .padding(.horizontal, 20)
                }
                
                ChipLayoutUI(alignment: .center, spacing: 8) {
                    ForEach(ExportQuality.allCases, id: \.rawValue) { quality in
                        SVChip(
                            model: .init(
                                id: quality.rawValue,
                                text:  quality.rawValue
                            ),
                            isSelected: store.exportType == quality) {
                                store.send(.qualityTapped(quality))
                            }
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Create Mockups")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
                
                SVToolbarItem(symbol: SVSymbols.Mockup.export, placement: .topBarTrailing){
                    store.send(.exportTapped)
                }
            }
            .photosPicker(
                isPresented: $isPhotosPickerPresented,
                selection: $store.selectedItems,
                maxSelectionCount: maxSelectionCount
            )
            .photosPicker(isPresented: $store.isMockupPhotoPickerPresented, selection: $store.selectedItem)
            .onChange(of: store.selectedItems) { oldValue, newValue in
                store.send(.newItemsAdded(newValue))
            }
            .onChange(of: store.selectedItem) { oldValue, newValue in
                store.send(.onMockupPhotoItemChange(newValue))
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .devicePicker(let store):
                iOSDevicePickerView(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .onChange(of: store.isDismissRequested) { _, shouldDismiss in
            if shouldDismiss {
                onDismiss()
            }
        }
    }
    
    @ViewBuilder
    func ActionButton(_ icon: String, title: String, action: @escaping ()->())-> some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: icon)
                .padding(12)
        }
        .buttonStyle(.plain)
        .optionalGlassEffect(.capsule)
    }
    
    private var maxSelectionCount: Int {
        if store.mockups.count < 10 {
            return 10 - store.mockups.count
        }else {
            return 0
        }
    }
}

