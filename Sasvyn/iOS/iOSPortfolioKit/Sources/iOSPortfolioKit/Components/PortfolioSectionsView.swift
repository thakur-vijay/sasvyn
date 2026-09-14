//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 13/09/26.
//

import SwiftUI
import SVDesignSystem

public enum PortfolioSection: String, CaseIterable, Identifiable, Hashable, Sendable{
    case home
    case projects
    case experiences
    case skills
    case contact
    
    public var id: String { rawValue }
    
    var label: String { rawValue.capitalized }
}

internal struct PortfolioSectionsView: View {
    let sections: [PortfolioSection]
    @Binding var selection: PortfolioSection?
    
    @State private var scrollPosition: ScrollPosition = .init()
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: SVSpacing.sectionContent) {
                ForEach(sections) { section in
                    SVChip(
                        model: .init(
                            id: section.id,
                            text: section.label
                        ),
                        isSelected: selection == section) {
                            withAnimation(.smooth) {
                                selection = section
                            }
                        }
                }
            }
            .padding(.horizontal, SVSpacing.screenHorizontal)
            .padding(.vertical, SVSpacing.large)
            .scrollTargetLayout()
        }
        .scrollPosition($scrollPosition, anchor: .center)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .onChange(of: selection) { oldValue, newValue in
            withAnimation(.snappy) {
                scrollPosition.scrollTo(id: newValue?.id)
            }
        }
    }
}
