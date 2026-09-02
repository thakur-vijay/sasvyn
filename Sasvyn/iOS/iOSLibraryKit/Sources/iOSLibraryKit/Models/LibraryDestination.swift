//
//  LibraryDestination.swift
//  iOSLibraryKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import Foundation

public enum LibraryDestination: String, Hashable {
    case experience = "Experience"
    case education = "Education"
    case skills = "Skills"
    case languages = "Languages"
    case about = "About"
    case socialLinks = "Social Links"
    case documents = "Documents"
    case mockups = "Mockups"
    
    var symbol: String {
        switch self {
        case .experience: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .skills: "wrench.and.screwdriver.fill"
        case .languages: "character.bubble.fill"
        case .about: "person.text.rectangle.fill"
        case .socialLinks: "link"
        case .documents: "doc.text.fill"
        case .mockups: "iphone"
        }
    }
    
}
