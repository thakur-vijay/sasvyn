//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVMockupKit
import SVDesignSystem

public struct iOSDevicePickerView: View {
    let store: StoreOf<iOSDevicePickerFeature>
    
    public init(store: StoreOf<iOSDevicePickerFeature>) {
        self.store = store
    }
    
    @State private var selectedGeneration: String? = Devices.generations.first {
        didSet {
            if selectedVariant == nil {
                selectedVariant = Devices.variants(for: selectedGeneration ?? "").first
            }
        }
    }
    
    @State private var selectedVariant: String?
    @State private var scrollPosition: ScrollPosition = .init()
    
    public var body: some View {
        let devices = Devices.devices(for: selectedGeneration ?? "", variant: selectedVariant ?? "")
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 12), count: 2), spacing: 12) {
                    ForEach(devices) { device in
                        if let uiImage = device.uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(uiImage.size.width / uiImage.size.height, contentMode: .fit)
                                .overlay {
                                    VStack(spacing: 15){
                                        Image(systemName: "plus.circle.fill")
                                            .font(.largeTitle.bold())
                                        Text(device.finish)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .contentShape(.rect)
                                .onTapGesture {
                                    store.send(.deviceSelected(device))
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Device")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top, spacing: 0) {
                iPhoneGenerationsView()
                    .background(.ultraThinMaterial)
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark") {
                        store.send(.closeTapped)
                    }
                }
            }
        }
        .task {
            if selectedVariant == nil {
                selectedVariant = Devices.variants(for: selectedGeneration ?? "").first
            }
        }
    }
    
    @ViewBuilder
    func iPhoneGenerationsView()-> some View {
        VStack(spacing: 16) {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(Devices.generations, id: \.self){ generation in
                        SVChip(
                            model: .init(id: generation, text: generation),
                            isSelected: selectedGeneration == generation) {
                                selectedVariant = nil
                                selectedGeneration = generation
                                withAnimation(.smooth) {
                                    scrollPosition.scrollTo(id: generation, anchor: .center)
                                }
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollPosition($scrollPosition)
            
            let variants = Devices.variants(for: selectedGeneration ?? "")
            ChipLayoutUI(alignment: .leading, spacing: 6) {
                ForEach(variants, id: \.self) { variant in
                    SVChip(
                        model: .init(id: variant, text: variant),
                        font: .caption,
                        isSelected: selectedVariant == variant) {
                            withAnimation(.smooth) {
                                selectedVariant = variant
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
