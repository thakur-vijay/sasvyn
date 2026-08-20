//
//  SkillCategory.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVDesignSystem

public enum DocumentCategory: String, CaseIterable, Codable, SVCategory {
    case resume
    case coverLetter
    case portfolio
    case projectDocumentation
    case caseStudy
    case technicalDocumentation
    case architectureAndDesign
    case apiDocumentation
    case certificatesAndCredentials
    case employmentAndExperience
    case education
    case presentations
    case notes
    case reports
    case other

    public var id: String { self.rawValue }

    public var title: String {
        switch self {
        case .resume:
            "Resume & CV"
        case .coverLetter:
            "Cover Letter"
        case .portfolio:
            "Portfolio"
        case .projectDocumentation:
            "Project Documentation"
        case .caseStudy:
            "Case Study"
        case .technicalDocumentation:
            "Technical Documentation"
        case .architectureAndDesign:
            "Architecture & Design"
        case .apiDocumentation:
            "API Documentation"
        case .certificatesAndCredentials:
            "Certificates & Credentials"
        case .employmentAndExperience:
            "Employment & Experience"
        case .education:
            "Education"
        case .presentations:
            "Presentations"
        case .notes:
            "Notes"
        case .reports:
            "Reports"
        case .other:
            "Other"
        }
    }

    public var order: Int {
        switch self {
        case .resume:
            0
        case .coverLetter:
            1
        case .portfolio:
            2
        case .projectDocumentation:
            3
        case .caseStudy:
            4
        case .technicalDocumentation:
            5
        case .architectureAndDesign:
            6
        case .apiDocumentation:
            7
        case .certificatesAndCredentials:
            8
        case .employmentAndExperience:
            9
        case .education:
            10
        case .presentations:
            11
        case .notes:
            12
        case .reports:
            13
        case .other:
            14
        }
    }
}
