//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit

struct EducationRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "educations"
    
    let id: String
    
    let degree: String
    
    let fieldOfStudy: String
    
    let institution: String
        
    let startDate: Date
    
    let endDate: Date
    
    let isPursuing: Bool
    
    let grade: String
    
    let gradeType: String
    
    let description: String
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, degree, institution, grade, description
        
        case fieldOfStudy = "field_of_study"
        
        case startDate = "start_date"
        
        case endDate = "end_date"
        
        case isPursuing = "is_pursuing"
        
        case gradeType = "grade_type"
        
        case createdAt = "created_at"
        
        case updatedAt = "updated_at"
        
    }
    
}

extension EducationRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        
        static let degree = SVColumnName("degree")
        
        static let fieldOfStudy = SVColumnName("field_of_study")
        
        static let institution = SVColumnName("institution")
                
        static let startDate = SVColumnName("start_date")
        
        static let endDate = SVColumnName("end_date")
        
        static let isPursuing = SVColumnName("is_pursuing")
        
        static let grade = SVColumnName("grade")
        
        static let gradeType = SVColumnName("grade_type")
        
        static let description = SVColumnName("description")
        
        static let createdAt = SVColumnName("created_at")
        
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension EducationRecord {
    
    nonisolated  enum Columns {
        
        static let id = SVColumn("id")
        
        static let degree = SVColumn("degree")
        
        static let fieldOfStudy = SVColumn("field_of_study")
        
        static let institution = SVColumn("institution")
                
        static let startDate = SVColumn("start_date")
        
        static let endDate = SVColumn("end_date")
        
        static let isPursuing = SVColumn("is_pursuing")
        
        static let grade = SVColumn("grade")
        
        static let gradeType = SVColumn("grade_type")
        
        static let description = SVColumn("description")
        
        static let createdAt = SVColumn("created_at")
        
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
