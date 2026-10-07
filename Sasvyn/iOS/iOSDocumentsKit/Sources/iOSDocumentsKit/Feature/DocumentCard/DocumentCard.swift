//
//  File.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 18/08/26.
//

import SwiftUI
import SVDocumentKit
import SVDesignSystem
import ComposableArchitecture

internal struct DocumentCard: View {
    let store: StoreOf<DocumentCardFeature>
    
    init(store: StoreOf<DocumentCardFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let url = store.document.url{
//                PDFThumbnailView(
//                    url: url,
//                    quickLook: quickLook,
//                    onDelete: onDelete
//                )
//                .task {
//                    print(url)
//                }
            }
            
            Text(store.document.name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(store.document.createdAt.formatted(date: .numeric, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(store.document.fileSize.formattedFileSize())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .task {
            print("Document Local url", store.document.localUrl)
            print("Document Remote url", store.document.url)
        }
    }
}
