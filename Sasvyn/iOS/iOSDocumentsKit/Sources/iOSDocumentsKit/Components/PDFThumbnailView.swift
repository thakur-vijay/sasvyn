//
//  PDFThumbnailView.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 18/08/26.
//

import SwiftUI
import PDFKit

struct PDFThumbnailView: View {
    
    let url: URL
    let quickLook: ()->()
    let onDelete: ()->()
    
    var body: some View {
        GeometryReader {
            let documentSize = $0.size
            if let thumbnail = makeThumbnail() {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: documentSize.width, height: documentSize.height)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .contentShape(.contextMenuPreview, .rect(cornerRadius: 12, style: .continuous))
                    .contextMenu {
                        Button(
                            "Quick Look",
                            systemImage: "eye",
                            action: quickLook
                        )
                        Divider()
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive,
                            action: onDelete
                        )
                    }
                    .onTapGesture(perform: quickLook)
            } else {
                Image(systemName: "doc.richtext")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(width: documentSize.width, height: documentSize.height)
                    .background(.fill, in: .rect(cornerRadius: 12, style: .continuous))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func makeThumbnail() -> UIImage? {
        guard let document = PDFDocument(url: url) else {
            return nil
        }
        guard let page = document.page(at: 0) else {
            return nil
        }
        
        let thumbnail = page.thumbnail(
            of: CGSize(width: 400, height: 533),
            for: .mediaBox
        )
        
        return thumbnail
    }
}
