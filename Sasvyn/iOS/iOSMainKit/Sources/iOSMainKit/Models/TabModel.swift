//
//  File.swift
//  iOSMainKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import Foundation

public enum TabModel: String, CaseIterable, Hashable{
    case home = "Home"
    case projects = "Projects"
    case library = "Library"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .home: "house"
        case .projects: "folder"
        case .library: "rectangle.stack.fill"
        case .settings: "gear"
        }
    }
}
