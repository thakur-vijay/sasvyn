//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import PhotosUI
import SVDesignSystem
import SVProjectKit

internal struct AppInfoView: View {
    @Bindable var store: StoreOf<AppInfoFeature>
    
    init(store: StoreOf<AppInfoFeature>) {
        self.store = store
    }
    
    var body: some View {
        let appIconURL = store.appIconURL
        let isEditable = store.mode.isEditable
    
        HStack(spacing: 12) {
            PhotosPicker(selection: $store.selectedAppIcon) {
                ZStack(alignment: .topTrailing) {
                    SVRemoteImage(
                        url: appIconURL,
                        size: .init(width: 100, height: 100),
                        shape: .rect(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    )
                    .optionalGlassEffect(
                        .rect(cornerRadius: 24, style: .continuous)
                    )

                    if isEditable {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(7)
                            .background(.regularMaterial, in: Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(.white.opacity(0.25), lineWidth: 0.5)
                            }
                            .padding(6)
                    }
                }
            }
            .allowsHitTesting(store.mode.isEditable)
            .onChange(of: store.selectedAppIcon) { oldValue, newValue in
                store.send(.selectedAppIconChanged(newValue))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(store.category?.title ?? "Select App Category")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.systemGray))
                    .contentShape(.rect)
                    .onTapGesture {
                        store.isAppCategoryPickerPresented.toggle()
                    }
                
                Group {
                    if store.mode.isEditable {
                        TextField(
                            "",
                            text: $store.name,
                            prompt: Text("Enter App Name").foregroundStyle(.gray)
                        )
                    }else {
                        Text(store.name)
                    }
                }
                .font(.title2.bold())
                Group {
                    if store.mode.isEditable {
                        TextField(
                            "",
                            text: $store.tagline,
                            prompt: Text("Enter App Tagline")
                        )
                    }else {
                        Text(store.tagline)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color(.systemGray))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .categoryPicker(
            isPresented: $store.isAppCategoryPickerPresented,
            title: "Select App Category",
            categories: AppCategory.allCases,
            selection: $store.category
        )
    }
    
    
    var RemoteAppIcon: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100, height: 100)
    }
    
   
}

