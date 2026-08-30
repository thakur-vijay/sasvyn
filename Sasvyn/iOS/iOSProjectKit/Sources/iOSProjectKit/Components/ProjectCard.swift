//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import SVRemoteImage
import SVProjectKit

public struct ProjectCard: View {
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
    
    @Environment(\.colorScheme) private var colorScheme
    public var body: some View {
        HStack(spacing: 12){
            SVRemoteImage(
                url: project.icon,
                size: .init(width: 100, height: 100),
                shape: .rect(cornerRadius: 24)
            )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(project.category?.title ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.systemGray))
                Text(project.name)
                Text(project.overview)
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray2))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                    
                Button("Edit", systemImage: "pencil"){
                    onTap(.edit)
                }
                
                Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
            } label: {
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
                    .frame(width: 30, height: 30, alignment: .trailing)
                    .contentShape(.rect)
            }

        }
        .padding(.vertical, 16)
        .background(.background)
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading, 102)
        }
        .contentShape(.rect)
        .onTapGesture {
            onTap(.view)
        }
    }
    
}
