//
//  SpokenLanguage.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public struct SpokenLanguage: Identifiable, Hashable, Sendable{
    public let id: String
    public var languageCode: String
    public var language: String
    public var proficiency: LanguageProficiency
    
    public init(
        id: String,
        languageCode: String = "",
        language: String = "",
        proficiency: LanguageProficiency = .elementary
    ) {
        self.id = id
        self.languageCode = languageCode
        self.language = language
        self.proficiency = proficiency
    }
}
