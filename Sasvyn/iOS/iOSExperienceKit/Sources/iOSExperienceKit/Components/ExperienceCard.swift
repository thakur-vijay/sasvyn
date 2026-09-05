import SVExperienceKit
import SwiftUI
import SVDesignSystem

internal struct ExperienceCard: View {
    let experience: Experience

    init(_ experience: Experience) { self.experience = experience }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            SVSymbols.experience.image
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.blue)
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
        }
    }

    private func formatted(_ date: Date) -> String { date.formatted(.dateTime.month(.abbreviated).year()) }
}
