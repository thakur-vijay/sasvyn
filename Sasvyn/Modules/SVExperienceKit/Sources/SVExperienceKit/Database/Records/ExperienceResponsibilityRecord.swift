import SVDatabaseKit

struct ExperienceResponsibilityRecord: Codable, SVFetchableRecord, SVPersistableRecord {
    static let databaseTableName = "experience_responsibilities"
    let id: String
    let experienceID: String
    let responsibility: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case id, responsibility, order
        case experienceID = "experience_id"
    }
}

extension ExperienceResponsibilityRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let experienceID = SVColumnName("experience_id")
        static let responsibility = SVColumnName("responsibility")
        static let order = SVColumnName("order")
    }
}
