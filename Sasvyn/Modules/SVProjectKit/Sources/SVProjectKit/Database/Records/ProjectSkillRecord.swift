//
//  ProjectSkillRecord.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation
import SVDatabaseKit

struct ProjectSkillRecord: Codable, SVFetchableRecord, SVPersistableRecord {
    static let databaseTableName = "project_skills"

    let projectID: String
    let skillID: String

    enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case skillID = "skill_id"
    }
}

extension ProjectSkillRecord {
    nonisolated enum ColumnNames {
        static let projectID = SVColumnName("project_id")
        static let skillID = SVColumnName("skill_id")
    }
}
