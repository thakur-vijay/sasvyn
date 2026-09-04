//
//  LibraryDestination.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI

public enum SettingsDestination: String, CaseIterable, Identifiable, Hashable {
    
    public var id: String { rawValue }
    case personalInformation = "Personal Information"
    case appearance = "Appearance"
    case privacy = "Privacy"
    case termsOfService = "Terms of Service"
    case helpAndSupport = "Help & Support"
    case signOut = "Sign Out"
    
    var symbol: String {
        switch self {
        case .personalInformation:
            return "person.text.rectangle.fill"
        case .appearance:
            return "circle.lefthalf.filled"
        case .privacy:
            return "lock.shield.fill"
        case .termsOfService:
            return "doc.plaintext.fill"
        case .helpAndSupport:
            return "questionmark.circle.fill"
        case .signOut:
            return "iphone.and.arrow.forward.outward"
        }
    }
   
    var isDestructive: Bool {
        return self == .signOut
    }
    
    var navigationLinkIndicatorVisibility: Visibility {
        return self == .signOut ? .hidden : .visible
    }
}
