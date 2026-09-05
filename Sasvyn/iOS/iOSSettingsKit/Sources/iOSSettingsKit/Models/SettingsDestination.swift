//
//  LibraryDestination.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI
import SVDesignSystem

public enum SettingsDestination: String, CaseIterable, Identifiable, Hashable {
    
    public var id: String { rawValue }
    case personalInformation = "Personal Information"
    case appearance = "Appearance"
    case privacy = "Privacy"
    case termsOfService = "Terms of Service"
    case helpAndSupport = "Help & Support"
    case signOut = "Sign Out"
    
    var symbol: SVSymbol {
        switch self {
        case .personalInformation:
            return SVSymbols.about
        case .appearance:
            return SVSymbols.appearance
        case .privacy:
            return SVSymbols.privacy
        case .termsOfService:
            return SVSymbols.terms
        case .helpAndSupport:
            return SVSymbols.support
        case .signOut:
            return SVSymbols.logout
        }
    }
   
    var isDestructive: Bool {
        return self == .signOut
    }
    
    var navigationLinkIndicatorVisibility: Visibility {
        return self == .signOut ? .hidden : .visible
    }
}
