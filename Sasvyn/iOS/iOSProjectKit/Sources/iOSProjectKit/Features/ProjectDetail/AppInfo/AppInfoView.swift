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
                        ),
                    )
                    .optionalGlassEffect(
                        .rect(cornerRadius: 24, style: .continuous)
                    )

                    if isEditable {
                        SVSymbols.Photo.add.image
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(7)
                            .optionalGlassEffect(.circle, isInteractive: true)
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
                
                SVEditableText(
                    description: $store.name,
                    placeholder: "Enter App Name",
                    isExpandable: false,
                    collapsedLineLimit: 1,
                    characterLimit: ProjectConfiguration.Content.appNameLimit,
                    isEditable: store.mode.isEditable,
                    font: .title2.bold()
                ) {
                    store.send(.infoChanged)
                }
                SVEditableText(
                    description: $store.tagline,
                    placeholder: "Enter App Tagline",
                    isExpandable: false,
                    collapsedLineLimit: 1,
                    characterLimit: ProjectConfiguration.Content.taglineLimit,
                    isEditable: store.mode.isEditable,
                    font: .subheadline,
                    foregroundStyle: Color(.systemGray)
                ) {
                    store.send(.infoChanged)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .categoryPicker(
            isPresented: $store.isAppCategoryPickerPresented,
            title: "Select App Category",
            categories: AppCategory.allCases,
            selection: .init(get: {
                return store.category
            }, set: { newValue in
                store.category = newValue
                store.send(.infoChanged)
            })
        )
    }
   
}

