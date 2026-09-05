//
//  File.swift
//  iOSEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSEducationsView: View {
    @Bindable var store: StoreOf<iOSEducationsFeature>
    
    public init(store: StoreOf<iOSEducationsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(store.educations) { education in
                    EducationCard(education)
                        .contextMenu {
                            Button("Edit", systemImage: SVSymbols.edit.name) {
                                store.send(.editTapped(education))
                            }
                            
                            Button("Delete", systemImage: SVSymbols.trash.name, role: .destructive){
                                store.send(.deleteTapped(education))
                            }
                        }
                }
            }
            .padding(20)
        }
        .overlay {
            if store.educations.isEmpty {
                SVContentUnavailableView(
                    title: "No Education Added",
                    symbol: SVSymbols.education,
                    description: "Add your education history to showcase your academic background."
                )
            }
        }
        .navigationTitle("Education")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            SVToolbarItem(symbol: SVSymbols.Add.plain, placement: .topBarTrailing) {
                store.send(.addTapped)
            }
        }
        .sheet(item: $store.scope(\.destination, action: \.destination)) { store in
            switch store.case {
            case .educationForm(let store):
                if #available(iOS 26.0, *) {
                    EducationFormView(store: store)
                        .interactiveDismissDisabled()
                        .onInteractiveResizeChange { trigger in
                            print(trigger)
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .alert($store.scope(\.alert, action: \.alert))
        .task {
            await store.send(.onTask).finish()
        }
    }
}
