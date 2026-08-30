//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVFoundation

public struct Education: Identifiable, Hashable, Sendable{
    public let id: String
    @Trim public var degree: String
    @Trim public var fieldOfStudy: String
    @Trim public var institution: String
    public var startDate: Date
    public var endDate: Date
    public var isPursuing: Bool
    @Constrained(.decimal) public var grade: String
    public var gradeType: GradeType
    @Trim public var description: String
    
    public init(
        id: String,
        degree: String = "",
        fieldOfStudy: String = "",
        institution: String = "",
        startDate: Date = .now,
        endDate: Date = .now,
        isPursuing: Bool = false,
        grade: String = "",
        gradeType: GradeType = .cgpa,
        description: String = ""
    ){
        self.id = id
        self.degree = degree
        self.fieldOfStudy = fieldOfStudy
        self.institution = institution
        self.startDate = startDate
        self.endDate = endDate
        self.isPursuing = isPursuing
        self._grade = Constrained(.decimal, wrappedValue: grade)
        self.gradeType = gradeType
        self.description = description
    }
}
