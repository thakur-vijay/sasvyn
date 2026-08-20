//
//  SwiftUIView.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import SwiftUI
import ComposableArchitecture
import QuickLook
import SVDocumentKit
import SVDesignSystem
import MusicKit

public struct iOSDocumentsView: View {
    @Bindable var store: StoreOf<iOSDocumentsFeature>
    
    public init(store: StoreOf<iOSDocumentsFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 12, alignment: .top),
                    count: 3
                ),
                spacing: 20
            ) {
                ForEach(store.documents) { document in
                    DocumentCard(document: document) {
                        store.send(.documentQuickLook(document))
                    } onDelete: {
                        store.send(.deleteDocumentTapped(document))
                    }
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .top){
            DocumentCategoryListView(selectedCategory: store.selectedDocumentCategory) { selectedCategory in
                store.send(.documentCategorySelected(selectedCategory))
            }
        }
        .navigationTitle("Documents")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    "",
                    systemImage: "document.badge.plus.fill"
                ) {
                    store.send(.addDocumentTapped)
                }
            }
        }
        .overlay {
            if store.documents.isEmpty {
                ContentUnavailableView(
                    "No Documents",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text(
                        "Add PDF documents to keep them ready for your portfolio."
                    )
                )
            }
        }
        .fileImporter(
            isPresented: $store.isDocumentPickerPresented,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            store.send(.onDocumentImport(result))
        }
        .quickLookPreview($store.selectedURL, in: store.documentURLS)
        .alert($store.scope(\.alert, action: \.alert))
        .categoryPicker(isPresented: $store.isDocumentCategoryPickerPresented, categories: DocumentCategory.allCases, selection: $store.pickedDocumentCategory){
            store.send(.onDocumentCategoryPickerDismiss)
        }
        .onChange(of: store.pickedDocumentCategory){ _, newValue in
            if let newValue {
                store.send(.addDocument(newValue))
            }
        }
        .task {
            await store.send(.onTask).finish()
        }

    
    }
}

