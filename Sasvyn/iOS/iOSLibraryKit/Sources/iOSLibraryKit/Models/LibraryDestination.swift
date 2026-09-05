//
//  LibraryDestination.swift
//  iOSLibraryKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import Foundation
import SVDesignSystem

public enum LibraryDestination: String, Identifiable, Hashable {
    
    public var id: String { rawValue }
    case experience = "Experience"
    case education = "Education"
    case skills = "Skills"
    case languages = "Languages"
    case about = "About"
    case socialLinks = "Social Links"
    case documents = "Documents"
    case mockups = "Mockups"
    
    var symbol: SVSymbol {
        switch self {
        case .experience: SVSymbols.experience
        case .education: SVSymbols.education
        case .skills: SVSymbols.skills
        case .languages: SVSymbols.language
        case .about: SVSymbols.about
        case .socialLinks: SVSymbols.Link.link
        case .documents: SVSymbols.Document.document
        case .mockups: SVSymbols.Mockup.iphone
        }
    }
    
}
