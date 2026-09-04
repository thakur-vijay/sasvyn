//
//  QuickActionsSection.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 02/09/26.
//


import SwiftUI
import SVDesignSystem

public struct QuickActionsSection: View {
    
    let action: (QuickAction)-> ()
    
    public enum QuickAction: CaseIterable, Identifiable {
        case addDocument
        case createMockup
        case addProject
        case editAbout
        
        public var id: Self { self }
        
        var title: String {
            switch self {
            case .addDocument:
                "Add Document"
            case .createMockup:
                "Create Mockup"
            case .addProject:
                "Add Project"
            case .editAbout:
                "Edit About"
            }
        }
        
        var systemImage: String {
            switch self {
            case .addDocument: SVSymbols.Document.Add.plain.name
            case .createMockup: SVSymbols.Mockup.create.name
            case .addProject: SVSymbols.Project.Add.plain.name
            case .editAbout: SVSymbols.about.name
            }
        }
    }
    
    public var body: some View {
        SVSection(title: "Quick Actions"){
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    actionCard(.addDocument)
                    actionCard(.createMockup)
                }
                
                GridRow {
                    actionCard(.addProject)
                    actionCard(.editAbout)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func actionCard(_ action: QuickAction) -> some View {
        Button {
            self.action(action)
        } label: {
            GroupBox {
                Text(action.title)
                    .font(.callout.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                Image(systemName: action.systemImage)
                    .font(.title2)
                    .frame(width: 30, height: 30)
                
            }
        }
        .buttonStyle(.plain)
    }
    
}
