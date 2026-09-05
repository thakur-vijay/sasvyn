//
//  File.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import Foundation
import SVDesignSystem

public enum TabModel: String, CaseIterable, Hashable{
    case home = "Home"
    case projects = "Projects"
    case library = "Library"
    case settings = "Settings"
    
    var symbol: SVSymbol {
        switch self {
        case .home: SVSymbols.home
        case .projects: SVSymbols.Project.projects
        case .library: SVSymbols.library
        case .settings: SVSymbols.settings
        }
    }
}
