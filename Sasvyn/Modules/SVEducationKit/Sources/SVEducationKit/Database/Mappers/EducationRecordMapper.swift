//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum EducationRecordMapper {

    nonisolated static func map(
        _ record: EducationRecord,
    ) -> Education? {
        guard let gradeType = GradeType(rawValue: record.gradeType) else { return nil}
        return Education(
            id: record.id,
            degree: record.degree,
            fieldOfStudy: record.fieldOfStudy,
            institution: record.institution,
            startDate: record.startDate,
            endDate: record.endDate,
            isPursuing: record.isPursuing,
            grade: record.grade,
            gradeType: gradeType,
            description: record.description
        )
    }
}

