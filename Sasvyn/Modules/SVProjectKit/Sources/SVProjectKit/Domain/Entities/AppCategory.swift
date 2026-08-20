//
//  AppCategory.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation
import SVDesignSystem

public enum AppCategory: String, CaseIterable, Codable, SVCategory {
    case productivity
    case business
    case finance
    case education
    case health
    case lifestyle
    case entertainment
    case social
    case communication
    case shopping
    case foodAndDrink
    case travel
    case navigation
    case photography
    case video
    case music
    case books
    case news
    case sports
    case games
    case utilities
    case weather
    case reference
    case developer
    case design
    case security
    case transportation
    case realEstate
    case automotive
    case government
    case kids
    case pets
    case dating
    case other
    
    public var id: String { rawValue }
}

extension AppCategory {
    public var title: String {
        switch self {
        case .productivity: "Productivity"
        case .business: "Business"
        case .finance: "Finance"
        case .education: "Education"
        case .health: "Health & Fitness"
        case .lifestyle: "Lifestyle"
        case .entertainment: "Entertainment"
        case .social: "Social"
        case .communication: "Communication"
        case .shopping: "Shopping"
        case .foodAndDrink: "Food & Drink"
        case .travel: "Travel"
        case .navigation: "Navigation"
        case .photography: "Photography"
        case .video: "Video"
        case .music: "Music"
        case .books: "Books"
        case .news: "News"
        case .sports: "Sports"
        case .games: "Games"
        case .utilities: "Utilities"
        case .weather: "Weather"
        case .reference: "Reference"
        case .developer: "Developer Tools"
        case .design: "Design"
        case .security: "Security"
        case .transportation: "Transportation"
        case .realEstate: "Real Estate"
        case .automotive: "Automotive"
        case .government: "Government"
        case .kids: "Kids"
        case .pets: "Pets"
        case .dating: "Dating"
        case .other: "Other"
        }
    }
}
