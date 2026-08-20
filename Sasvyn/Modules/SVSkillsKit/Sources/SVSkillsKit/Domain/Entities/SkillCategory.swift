//
//  SkillCategory.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVDesignSystem

public enum SkillCategory: String, CaseIterable, Codable, SVCategory {
    case languages
    case frameworks
    case architecture
    case networking
    case dataAndPersistence
    case backendAndCloud
    case uiAndDesign
    case mapsAndLocation
    case authenticationAndSecurity
    case payments
    case testing
    case cicdAndDeployment
    case developmentTools
    case analyticsAndMonitoring
    case notificationsAndMessaging
    case deviceAndHardware
    case performance
    case other

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .languages:
            "Languages"
        case .frameworks:
            "Frameworks"
        case .architecture:
            "Architecture"
        case .networking:
            "Networking"
        case .dataAndPersistence:
            "Data & Persistence"
        case .backendAndCloud:
            "Backend & Cloud"
        case .uiAndDesign:
            "UI & Design"
        case .mapsAndLocation:
            "Maps & Location"
        case .authenticationAndSecurity:
            "Authentication & Security"
        case .payments:
            "Payments"
        case .testing:
            "Testing"
        case .cicdAndDeployment:
            "CI/CD & Deployment"
        case .developmentTools:
            "Development Tools"
        case .analyticsAndMonitoring:
            "Analytics & Monitoring"
        case .notificationsAndMessaging:
            "Notifications & Messaging"
        case .deviceAndHardware:
            "Device & Hardware"
        case .performance:
            "Performance"
        case .other:
            "Other"
        }
    }
    
    public var order: Int {
        switch self {
        case .languages:
            0
        case .frameworks:
            1
        case .architecture:
            2
        case .networking:
            3
        case .dataAndPersistence:
            4
        case .backendAndCloud:
            5
        case .uiAndDesign:
            6
        case .mapsAndLocation:
            7
        case .authenticationAndSecurity:
            8
        case .payments:
            9
        case .testing:
            10
        case .cicdAndDeployment:
            11
        case .developmentTools:
            12
        case .analyticsAndMonitoring:
            13
        case .notificationsAndMessaging:
            14
        case .deviceAndHardware:
            15
        case .performance:
            16
        case .other:
            17
        }
    }
}
