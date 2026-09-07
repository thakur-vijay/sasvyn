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
                        url: .init(string: ""),
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
                    value: "Vijay Thakur"
                ) {
                    store.send(.destinationTapped(.name))
                }
                
                SVListRow(
                    PersonalInformationDestination.email.rawValue,
                    value: "thakurvijay0006@gmail.com"
                ) {
                    store.send(.destinationTapped(.email))
                }
                SVListRow(
                    PersonalInformationDestination.dateOfBirth.rawValue,
                    value: "21 September 2001"
                ){
                    store.send(.destinationTapped(.dateOfBirth))
                }
                
                SVListRow(
                    PersonalInformationDestination.phoneNo.rawValue,
                    value: "+91 8146408509"
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
    }
}
