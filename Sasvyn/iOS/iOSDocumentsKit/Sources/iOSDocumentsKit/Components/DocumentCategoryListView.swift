//
//  DocumentCategoryListView.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 19/08/26.
//

import SwiftUI
import SVDocumentKit
import SVDesignSystem

struct DocumentCategoryListView: View {
    var selectedCategory: DocumentCategory?
    var onSelection: (DocumentCategory?)->()
    
    @State private var scrollPosition: ScrollPosition = .init()
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                SVChip(
                    model: .init(id: "all", text: "All"),
                    isSelected: selectedCategory == nil) {
                        scrollPosition.scrollTo(id: "all", anchor: .center)
                        onSelection(nil)
                    }
                ForEach(DocumentCategory.allCases) { category in
                    SVChip(
                        model: .init(id: category.rawValue, text: category.title),
                        isSelected: selectedCategory == category) {
                            scrollPosition.scrollTo(id: category.rawValue, anchor: .center)
                            onSelection(category)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition($scrollPosition, anchor: .center)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .safeAreaPadding(.horizontal, 20)
        .safeAreaPadding(.vertical, 15)
        .animation(.smooth, value: scrollPosition)
    }
}
