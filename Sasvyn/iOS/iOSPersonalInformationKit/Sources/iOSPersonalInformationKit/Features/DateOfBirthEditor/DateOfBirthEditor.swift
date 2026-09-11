//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 07/09/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct DateOfBirthEditor: View {
    @Bindable var store: StoreOf<DateOfBirthEditorFeature>
    
    public init(store: StoreOf<DateOfBirthEditorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                SVListRow(
                    "Date of birth",
                    value: store.dateOfBirth.formatted(date: .abbreviated, time: .omitted),
                    showsDisclosureIndicator: false
                )
                
            }
            Section {
                SVDatePicker(
                    "",
                    selection: $store.dateOfBirth,
                    displayedComponents: .date,
                    style: .graphical
                )
            }
        }
        .listSectionSpacing(.compact)
        .toolbar {
            SVToolbarItem.close {
                store.send(.closeTapped)
            }
            
            SVToolbarItem.check(store.isDetailsReady) {
                store.send(.saveTapped)
            }
        }
        .isASheet(true)
    }
}
