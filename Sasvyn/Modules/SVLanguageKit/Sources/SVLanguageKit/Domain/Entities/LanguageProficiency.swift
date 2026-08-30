//
//  LanguageProficiency.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public enum LanguageProficiency: Int, CaseIterable, Codable, Hashable, Sendable {
    case elementary = 1
    case limitedWorking = 2
    case professionalWorking = 3
    case fullProfessional = 4
    case nativeBilingual = 5

    public var displayName: String {
        switch self {
        case .elementary:
            "Elementary Proficiency"
        case .limitedWorking:
            "Limited Working Proficiency"
        case .professionalWorking:
            "Professional Working Proficiency"
        case .fullProfessional:
            "Full Professional Proficiency"
        case .nativeBilingual:
            "Native / Bilingual Proficiency"
        }
    }
}
