//
//  SkillCategory.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import Foundation

public enum SkillCategory: String, CaseIterable, Codable, Equatable, Identifiable, Sendable {
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

    public var id: Self { self }

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
}
