//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import iOSProjectKit

internal struct RecentProjectsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Projects")
                    .font(.subheadline.bold())
                Spacer()
                Button("See All") {
                    
                }
                .font(.subheadline)
                .foregroundStyle(.purple.tertiary)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(1...10, id: \.self){ _ in
                    ProjectCard(project: .init()) {
                        
                    } onDelete: {
                        
                    }
                }
            }
        }
    }
}
