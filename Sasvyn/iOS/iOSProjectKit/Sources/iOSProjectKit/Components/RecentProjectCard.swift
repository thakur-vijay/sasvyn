//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 01/09/26.
//

import SwiftUI
import SVRemoteImage
import SVProjectKit

public struct RecentProjectCard: View {
    private let project: Project
    private let onTap: (ProjectMode)->()
    private let onDelete: ()->()
    public init(
        project: Project,
        onTap: @escaping (ProjectMode) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.project = project
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    
    public var body: some View {
        VStack(spacing: 12){
            SVRemoteImage(
                url: project.icon,
                size: .init(width: 140, height: 140),
                shape: .rect(cornerRadius: 24)
            )
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 24, style: .continuous))
            .contextMenu {
                Button("Edit", systemImage: "pencil"){
                    onTap(.edit)
                }
                
                Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
            }
            Text(project.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
        }
        .frame(width: 140)
        .contentShape(.rect)
        .onTapGesture {
            onTap(.view)
        }
    }
}
