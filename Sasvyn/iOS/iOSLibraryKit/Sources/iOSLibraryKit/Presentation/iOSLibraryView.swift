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
import SVDesignSystem
import iOSDocumentsKit
import iOSMockupKit
import iOSEducationKit
import iOSLanguageKit
import iOSSocialLinkKit
import iOSExperienceKit

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
                        ForEach(section.rows) { row in
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
            .listStyle(.plain)
            .navigationTitle("Library")
        } destination: { store in
            switch store.case {
            case .skills(let store):
                iOSSKillsView(store: store)
            case .about(let store):
                iOSAboutView(store: store)
            case .documents(let store):
                iOSDocumentsView(store: store)
            case .mockups(let store):
                iOSMockupsView(store: store)
            case .education(let store):
                iOSEducationsView(store: store)
            case .languages(let store):
                iOSLanguagesView(store: store)
            case .socialLinks(let store):
                iOSSocialLinksView(store: store)
            case .experiences(let store):
                iOSExperiencesView(store: store)
            }
        }
    }

}
