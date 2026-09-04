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
        case editPortfolio
        
        public var id: Self { self }
        
        var title: String {
            switch self {
            case .addDocument:
                "Add Document"
            case .createMockup:
                "Create Mockup"
            case .addProject:
                "Add Project"
            case .editPortfolio:
                "Edit Portfolio"
            }
        }
        
        var systemImage: String {
            switch self {
            case .addDocument:
                "doc.badge.plus"
            case .createMockup:
                "rectangle.on.rectangle"
            case .addProject:
                "folder.badge.plus"
            case .editPortfolio:
                "person.text.rectangle"
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
                    actionCard(.editPortfolio)
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
