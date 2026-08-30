//
//  ChatListLocalDataSource.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

final class EducationsLocalDataSource: @unchecked Sendable{
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func fetch() async throws -> [EducationRecord]{
        return try await database.read {database in
            try database.fetchAll(EducationRecord.self, sorting: [
                .descending(EducationRecord.ColumnNames.startDate)
            ])
        }
    }

    func create(_ education: Education) async throws {
        try await database.write { db in

            let record = EducationRecord(
                id: education.id,
                degree: education.degree,
                fieldOfStudy: education.fieldOfStudy,
                institution: education.institution,
                startDate: education.startDate,
                endDate: education.endDate,
                isPursuing: education.isPursuing,
                grade: education.grade,
                gradeType: education.gradeType.rawValue,
                description: education.degree,
                createdAt: .now,
                updatedAt: .now
            )
            try db.insert(record)
        }
    }
    
    func update(_ education: Education) async throws {
        try await database.write { db in
            try db.update(
                table: EducationRecord.databaseTableName,
                values: [
                    EducationRecord.ColumnNames.degree: .text(education.degree),
                    EducationRecord.ColumnNames.fieldOfStudy: .text(education.fieldOfStudy),
                    EducationRecord.ColumnNames.institution: .text(education.institution),
                    EducationRecord.ColumnNames.startDate: .date(education.startDate),
                    EducationRecord.ColumnNames.endDate: .date(education.endDate),
                    EducationRecord.ColumnNames.isPursuing: .bool(education.isPursuing),
                    EducationRecord.ColumnNames.grade: .text(education.grade),
                    EducationRecord.ColumnNames.gradeType: .text(education.gradeType.rawValue),
                    EducationRecord.ColumnNames.description: .text(education.description),
                    EducationRecord.ColumnNames.updatedAt: .date(.now),
                ],
                whereColumn: EducationRecord.ColumnNames.id,
                equals: .text(education.id)
            )
        }
    }
    
    func delete(id: String) async throws {
        try await database.write { db in
            try db.delete(EducationRecord.self, key: id)
        }
    }
}
