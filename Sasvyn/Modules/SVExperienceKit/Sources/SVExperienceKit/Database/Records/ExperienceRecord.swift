import Foundation
import SVDatabaseKit

struct ExperienceRecord: Codable, SVFetchableRecord, SVPersistableRecord {
    static let databaseTableName = "experiences"
    let id: String
    let role: String
    let company: String
    let startDate: Date
    let endDate: Date?
    let isCurrentlyWorking: Bool

    enum CodingKeys: String, CodingKey {
        case id, role, company
        case startDate = "start_date"
        case endDate = "end_date"
        case isCurrentlyWorking = "is_currently_working"
    }
}

extension ExperienceRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let role = SVColumnName("role")
        static let company = SVColumnName("company")
        static let startDate = SVColumnName("start_date")
        static let endDate = SVColumnName("end_date")
        static let isCurrentlyWorking = SVColumnName("is_currently_working")
    }
}
