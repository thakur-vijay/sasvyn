//
//  File.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 18/08/26.
//

import SwiftUI
import SVDocumentKit
import SVDesignSystem

internal struct DocumentCard: View {
    let document: Document
    let quickLook: ()->()
    let onDelete: ()->()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            PDFThumbnailView(
                url: document.url,
                quickLook: quickLook,
                onDelete: onDelete
            )
            
            Text(document.name)
                .font(.subheadline)
                .fontWeight(.medium)

            Text(document.createdAt.formatted(date: .numeric, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(document.fileSize.formattedFileSize())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
