//
//  GradeType.swift
//  SVEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import Foundation

public enum GradeType: String, CaseIterable, Hashable, Sendable{
    case cgpa = "CGPA"
    case gpa = "GPA"
    case percentage = "%"
}
