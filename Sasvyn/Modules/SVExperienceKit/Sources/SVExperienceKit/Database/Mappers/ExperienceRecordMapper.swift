import Foundation

enum ExperienceRecordMapper {
    nonisolated static func map(_ experience: Experience) -> ExperienceRecord {
        ExperienceRecord(
            id: experience.id,
            role: experience.role,
            company: experience.company,
            startDate: experience.startDate,
            endDate: experience.isCurrentlyWorking ? nil : experience.endDate,
            isCurrentlyWorking: experience.isCurrentlyWorking
        )
    }

    nonisolated static func mapResponsibilities(
        _ experience: Experience
    ) -> [ExperienceResponsibilityRecord] {
        experience.responsibilities.enumerated().map { index, responsibility in
            ExperienceResponsibilityRecord(
                id: responsibility.id,
                experienceID: experience.id,
                responsibility: responsibility.responsibility,
                order: index
            )
        }
    }

    nonisolated static func map(
        _ record: ExperienceRecord,
        responsibilities: [ExperienceResponsibilityRecord]
    ) -> Experience {
        Experience(
            id: record.id,
            role: record.role,
            company: record.company,
            startDate: record.startDate,
            endDate: record.endDate,
            isCurrentlyWorking: record.isCurrentlyWorking,
            responsibilities: responsibilities
                .sorted { $0.order < $1.order
                }
                .map {
                    ExperienceResponsibility(
                        id: $0.id,
                        experienceID: $0.experienceID,
                        responsibility: $0.responsibility
                    )
                }
        )
    }
}
