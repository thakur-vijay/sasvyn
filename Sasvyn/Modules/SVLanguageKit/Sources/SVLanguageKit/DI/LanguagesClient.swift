//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct LanguagesClient: Sendable{
    public var loadLanguages:
    @Sendable () async throws -> [Language]
    
    public var fetch:
    @Sendable () async throws -> [SpokenLanguage]
    
    public var delete:
    @Sendable (_ id: String) async throws -> Void
    
    public var save:
    @Sendable (_ language: SpokenLanguage) async throws -> Void
    
}

extension LanguagesClient {

    static func live(
        loadLanguagesJSONUseCase: LoadLanguagesJSONUseCase,
        fetchSpokenLanguagesUseCase: FetchSpokenLanguagesUseCase,
        saveSpokenLanguageUseCase: SaveSpokenLanguageUseCase,
        deleteSpokenLanguageUseCase: DeleteSpokenLanguageUseCase
    ) -> Self {
        Self {
            try await loadLanguagesJSONUseCase.execute()
        } fetch: {
            try await fetchSpokenLanguagesUseCase.execute()
        } delete: { id in
            try await deleteSpokenLanguageUseCase.execute(id)
        } save: { language in
            try await saveSpokenLanguageUseCase.execute(language)
        }
    }
}

extension LanguagesClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } fetch: {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } save: { education in
        fatalError("Unimplemented")
    }
}

extension LanguagesClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } fetch: {
        return []
    } delete: { id in
        
    } save: { education in
        
    }

}

public extension DependencyValues {

    var languagesClient: LanguagesClient {
        get { self[LanguagesClient.self] }
        set { self[LanguagesClient.self] = newValue }
    }
}
