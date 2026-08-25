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

extension View {
    @ViewBuilder
    func optionalContextMenu<M, P>(
        _ isEnabled: Bool,
        @ContentBuilder menuItems: () -> M,
        @ContentBuilder preview: () -> P
    ) -> some View where M : View, P : View {
        if isEnabled {
            self
                .contextMenu(menuItems: menuItems, preview: preview)
        }else {
            self
        }
    }
    
    @ViewBuilder
    func isASheet(_ isEnabled: Bool)-> some View {
        if isEnabled {
            NavigationStack {
                self
            }
        }else {
            self
        }
    }
}

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
                    let isUserInteractionDisabled = (store.maxSelection == store.selectedMockupIds.count) && (!store.selectedMockupIds.contains(mockup.id))
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
                            Button("Save to Photos", systemImage: "photo") {
                                
                            }
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                store.send(.deleteTapped(mockup))
                            }
                        }else {
                            Button("Select", systemImage: "checkmark.circle") {
                                
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
            }
        }
        .isASheet(store.mode == .picker)
        .task {
            await store.send(.onTask).finish()
        }
    }
    
}
