import SwiftUI
import SVDesignSystem

internal struct QuickActionsSection: View {

    private enum QuickAction: CaseIterable, Identifiable {
        case addDocument
        case createMockup
        case addProject
        case editPortfolio

        var id: Self { self }

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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.bold())

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
            handle(action)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: action.systemImage)
                    .font(.title2)

                Text(action.title)
                    .font(.callout.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
            .background {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(.secondary.opacity(0.1))
            }
        }
        .buttonStyle(.plain)
    }

    private func handle(_ action: QuickAction) {
        switch action {
        case .addDocument:
            break
        case .createMockup:
            break
        case .addProject:
            break
        case .editPortfolio:
            break
        }
    }
}