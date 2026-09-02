import Foundation
import SVDatabaseKit

final class ExperiencesLocalDataSource: @unchecked Sendable {
    private let database: AppDatabase

    init(database: AppDatabase) {
        self.database = database
    }

    func fetch() async throws -> [(ExperienceRecord, [ExperienceResponsibilityRecord])] {
        try await database.read { db in
            let experiences = try db.fetchAll(
                ExperienceRecord.self,
                sorting: [.descending(ExperienceRecord.ColumnNames.startDate)]
            )
            return try experiences.map { experience in
                let responsibilities = try db.fetch(
                    ExperienceResponsibilityRecord.self,
                    sql: """
                    SELECT id, experience_id, responsibility, "order"
                    FROM experience_responsibilities
                    WHERE experience_id = ?
                    ORDER BY "order" ASC
                    """,
                    arguments: [.text(experience.id)]
                )
                return (experience, responsibilities)
            }
        }
    }

    func create(_ experience: Experience) async throws {
        try await database.write { db in
            try self.insert(experience, db: db)
        }
    }

    func update(_ experience: Experience) async throws {
        try await database.write { db in
            try db.update(
                table: ExperienceRecord.databaseTableName,
                values: [
                    ExperienceRecord.ColumnNames.role: .text(experience.role),
                    ExperienceRecord.ColumnNames.company: .text(experience.company),
                    ExperienceRecord.ColumnNames.startDate: .date(experience.startDate),
                    ExperienceRecord.ColumnNames.endDate: experience.endDate.map(SVDatabaseValue.date) ?? .null,
                    ExperienceRecord.ColumnNames.isCurrentlyWorking: .bool(experience.isCurrentlyWorking),
                ],
                whereColumn: ExperienceRecord.ColumnNames.id,
                equals: .text(experience.id)
            )
            try db.execute(
                sql: "DELETE FROM experience_responsibilities WHERE experience_id = ?",
                arguments: [.text(experience.id)]
            )
            try self.insertResponsibilities(for: experience, db: db)
        }
    }

    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(ExperienceRecord.self, key: id)
        }
    }

    private func insert(_ experience: Experience, db: SVDatabase) throws {
        try db.insert(ExperienceRecordMapper.map(experience))
        try insertResponsibilities(for: experience, db: db)
    }

    private func insertResponsibilities(for experience: Experience, db: SVDatabase) throws {
        for record in ExperienceRecordMapper.mapResponsibilities(experience) {
            try db.insert(record)
        }
    }
}
