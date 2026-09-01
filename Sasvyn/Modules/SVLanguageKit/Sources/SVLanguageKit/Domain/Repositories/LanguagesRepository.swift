//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public protocol LanguagesRepository: Sendable{
    func loadLanguagesJSON()async throws-> [Language]
    func fetch() async throws -> [SpokenLanguage]
    func save(_ language: SpokenLanguage) async throws
    func delete(_ id: String) async throws
}
