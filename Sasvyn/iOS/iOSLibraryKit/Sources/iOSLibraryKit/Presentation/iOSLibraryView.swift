//
//  File.swift
//  iOSLibraryKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import iOSSkillsKit
import iOSAboutKit

public struct iOSLibraryView: View {
    @Bindable var store: StoreOf<iOSLibraryFeature>

    public init(store: StoreOf<iOSLibraryFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            List {
                ForEach(LibrarySectionModel.sections) { section in
                    Section(section.title) {
                        ForEach(section.rows, id: \.rawValue) { row in
                            Button {
                                store.send(.pathTapped(row))
                            } label: {
                                NavigationLink(value: row) {
                                    Label(
                                        row.rawValue,
                                        systemImage: row.symbol
                                    )
                                }
                                .allowsHitTesting(false)
                            }

                        }
                    }
                }
            }
            .navigationTitle("Library")
        } destination: { store in
            switch store.case {
            case .skills(let store):
                iOSSKillsView(store: store)
            case .about(let store):
                iOSAboutView(store: store)
            }
        }
    }

}
