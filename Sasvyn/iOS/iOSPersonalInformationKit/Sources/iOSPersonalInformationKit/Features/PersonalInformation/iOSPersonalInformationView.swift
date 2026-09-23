//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVRemoteImage
import Photos
import SVFoundation

public struct iOSPersonalInfomationView: View {
    @Bindable var store: StoreOf<iOSPersonalInfomationFeature>
    
    public init(store: StoreOf<iOSPersonalInfomationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                VStack(spacing: 12){
                    SVRemoteImage(
                        url: store.user.imageLocalUrl ?? URL(string: store.user.imageUrl ?? ""),
                        size: .init(width: 180, height: 180),
                        contentMode: .fill,
                        shape: .circle,
                    )
                    
                    SVButton(
                        "Change",
                        systemImage: SVSymbols.Photo.add.name,
                        size: .small,
                        width: .intrinsic) {
                            store.send(.changeProfilePicTapped)
                        }
                }
                .padding(.bottom, 20)
                .clearListStyle()
            }
            
            Section {
                SVListRow(
                    PersonalInformationDestination.name.rawValue,
                    value: store.user.fullName
                ) {
                    store.send(.destinationTapped(.name))
                }
                
                SVListRow(
                    PersonalInformationDestination.email.rawValue,
                    value: store.user.email
                ) {
                    store.send(.destinationTapped(.email))
                }
                SVListRow(
                    PersonalInformationDestination.dateOfBirth.rawValue,
                    value: store.user.dateOfBirth?.formatted(.longDate) ?? "Select"
                ){
                    store.send(.destinationTapped(.dateOfBirth))
                }
                
                SVListRow(
                    PersonalInformationDestination.phoneNo.rawValue,
                    value: "Select"
                ){
                    store.send(.destinationTapped(.phoneNo))
                }
            }
            
        }
        .listSectionSpacing(.custom(20))
        .navigationTitle("Personal Information")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .nameEditor(let store):
                NameEditor(store: store)
                    .interactiveDismissDisabled()
            case .dateOfBirthEditor(let store):
                DateOfBirthEditor(store: store)
                    .interactiveDismissDisabled()
            }
        }
        .photosPicker(
            isPresented: $store.isPhotosPickerPresented,
            selection: $store.selectedItem,
            matching: .images,
        )
        .onChange(of: store.selectedItem) { oldValue, newValue in
            store.send(.onProfilePicChanged)
        }
    }
}
