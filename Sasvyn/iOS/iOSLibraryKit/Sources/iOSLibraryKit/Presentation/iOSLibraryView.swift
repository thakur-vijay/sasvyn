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

public struct iOSLibraryView: View {
    @Bindable var store: StoreOf<iOSLibraryFeature>

    public init(store: StoreOf<iOSLibraryFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)){
            SVList {
                for section in LibrarySectionModel.sections {
                    SVSection(section.title){
                        for row in section.rows {
                            SVRow(row.rawValue, systemImage: row.symbol) {
                                store.send(.pathTapped(row))
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
            case .documents(let store):
                iOSDocumentsView(store: store)
            case .mockups(let store):
                iOSMockupsView(store: store)
            }
        }
    }

}


public struct SVList: View {

    private let content: [SVListItem]

    public init(
        @SVListBuilder content: () -> [SVListItem]
    ) {
        self.content = content()
    }

    public var body: some View {
        List {
            ForEach(content) { item in
                item.view
            }
        }
        .listStyle(.insetGrouped)
    }
}


// MARK: - SVListItem

public struct SVListItem: Identifiable {

    public let id = UUID()
    fileprivate let view: AnyView

    fileprivate init(view: AnyView) {
        self.view = view
    }

    fileprivate init(_ row: SVRow) {
        self.view = AnyView(row)
    }

    fileprivate init(_ section: SVSection) {
        self.view = AnyView(section)
    }
}

@resultBuilder
public enum SVListBuilder {

    // MARK: - SVRow

    public static func buildExpression(
        _ row: SVRow
    ) -> [SVListItem] {
        [SVListItem(row)]
    }

    // MARK: - SVSection

    public static func buildExpression(
        _ section: SVSection
    ) -> [SVListItem] {
        [SVListItem(section)]
    }

    // MARK: - ForEach -> SVRow

    public static func buildExpression<Data, ID>(
        _ forEach: ForEach<Data, ID, SVRow>
    ) -> [SVListItem]
    where
        Data: RandomAccessCollection,
        ID: Hashable
    {
        [SVListItem(
            view: AnyView(forEach)
        )]
    }

    // MARK: - ForEach -> SVSection

    public static func buildExpression<Data, ID>(
        _ forEach: ForEach<Data, ID, SVSection>
    ) -> [SVListItem]
    where
        Data: RandomAccessCollection,
        ID: Hashable
    {
        [SVListItem(
            view: AnyView(forEach)
        )]
    }

    // MARK: - Block

    public static func buildBlock(
        _ components: [SVListItem]...
    ) -> [SVListItem] {
        components.flatMap { $0 }
    }

    // MARK: - Optional

    public static func buildOptional(
        _ component: [SVListItem]?
    ) -> [SVListItem] {
        component ?? []
    }

    // MARK: - Either

    public static func buildEither(
        first component: [SVListItem]
    ) -> [SVListItem] {
        component
    }

    public static func buildEither(
        second component: [SVListItem]
    ) -> [SVListItem] {
        component
    }

    // MARK: - Array / ForEach-style loops

    public static func buildArray(
        _ components: [[SVListItem]]
    ) -> [SVListItem] {
        components.flatMap { $0 }
    }
}

public struct SVSection: View {

    private let title: String?
    private let systemImage: String?
    private let rows: [SVRow]

    public init(
        _ title: String? = nil,
        systemImage: String? = nil,
        @SVSectionBuilder content: () -> [SVRow]
    ) {
        self.title = title
        self.systemImage = systemImage
        self.rows = content()
    }

    public var body: some View {
        Section {
            ForEach(rows) { row in
                row
            }
        } header: {
            if let title {
                Label(title, systemImage: systemImage ?? "")
            }
        }
    }
}

@resultBuilder
public enum SVSectionBuilder {

    public static func buildExpression(
        _ row: SVRow
    ) -> [SVRow] {
        [row]
    }

    public static func buildBlock(
        _ components: [SVRow]...
    ) -> [SVRow] {
        components.flatMap { $0 }
    }

    public static func buildArray(
        _ components: [[SVRow]]
    ) -> [SVRow] {
        components.flatMap { $0 }
    }

    public static func buildOptional(
        _ component: [SVRow]?
    ) -> [SVRow] {
        component ?? []
    }

    public static func buildEither(
        first component: [SVRow]
    ) -> [SVRow] {
        component
    }

    public static func buildEither(
        second component: [SVRow]
    ) -> [SVRow] {
        component
    }
}

public struct SVRow: View, Identifiable {

    public let id = UUID()
    private let title: String
    private let systemImage: String
    private let action: ()->()
    public init(
        _ title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            NavigationLink(value: title) {
                Label(
                    title,
                    systemImage: systemImage
                )
            }
            .allowsHitTesting(false)
        }
    }
}
