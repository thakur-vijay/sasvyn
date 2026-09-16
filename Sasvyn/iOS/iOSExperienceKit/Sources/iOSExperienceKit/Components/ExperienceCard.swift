import SVExperienceKit
import SwiftUI
import SVDesignSystem

public struct ExperienceCard: View {
    let experience: Experience
    let mode: ExperienceViewMode
    let isSelected: Bool
    let onEditTap: ()-> ()
    let onDeleteTap: ()-> ()

    public init(
        _ experience: Experience,
        mode: ExperienceViewMode,
        isSelected: Bool,
        onEditTap: @escaping ()-> (),
        onDeleteTap: @escaping ()-> ()
    ) {
        self.experience = experience
        self.mode = mode
        self.isSelected = isSelected
        self.onEditTap = onEditTap
        self.onDeleteTap = onDeleteTap
    }

    public var body: some View {
        HStack(spacing: 12) {
            SVSymbols.experience.image
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(experience.role)
                        .font(.title3)
                        .fontWeight(.bold)
                    if experience.isCurrentlyWorking {
                        Text("Current")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.blue.opacity(0.15), in: Capsule())
                            .foregroundStyle(.blue)
                    }
                }
                Text(experience.company)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text("\(formatted(experience.startDate)) – \(experience.isCurrentlyWorking ? "Present" : experience.endDate.map(formatted) ?? "—")")
                    .font(.callout)
                    .foregroundStyle(.gray)
                DisclosureGroup("Responsibilities") {
                    ForEach(experience.responsibilities) { responsibility in
                        Text("• \(responsibility.responsibility)")
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .font(.callout)
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if mode == .screen{
                Menu {
                    Button(
                        "Edit",
                        systemImage: SVSymbols.edit.name,
                        action: onEditTap
                    )
                    Button(
                        "Delete",
                        systemImage: SVSymbols.trash.name,
                        role: .destructive,
                        action: onDeleteTap
                    )
                } label: {
                    SVSymbols.`3Dots`.image
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                        .frame(width: 30, height: 30, alignment: .trailing)
                        .contentShape(.rect)
                }
            }else {
                if isSelected {
                    SVSymbols.Check.circle.image
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        return date.formatted(.dateTime.month(.abbreviated).year())
    }
}
