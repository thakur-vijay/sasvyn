//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import iOSProjectKit
import SVDesignSystem

internal struct RecentProjectsSection: View {
    var body: some View {
        SVSection(title: "Recent Projects") {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { _ in
                        RecentProjectCard(project: .init()) { mode in
                            
                        } onDelete: {
                            
                        }

                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
