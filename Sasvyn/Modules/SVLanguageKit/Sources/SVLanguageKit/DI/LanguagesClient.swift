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
    @Sendable () -> AsyncStream<[SpokenLanguage]>
    
    public var delete:
    @Sendable (_ id: String) async throws -> Void
    
    public var add:
    @Sendable (_ language: SpokenLanguage) async throws -> Void
    
    public var update:
    @Sendable (_ language: SpokenLanguage) async throws -> Void
    
}

extension LanguagesClient {

    static func live(
        loadLanguagesJSONUseCase: LoadLanguagesJSONUseCase,
        fetchSpokenLanguagesUseCase: FetchSpokenLanguagesUseCase,
        addSpokenLanguageUseCase: AddSpokenLanguageUseCase,
        updateSpokenLanguageUseCase: UpdateSpokenLanguageUseCase,
        deleteSpokenLanguageUseCase: DeleteSpokenLanguageUseCase
    ) -> Self {
        Self {
            try await loadLanguagesJSONUseCase.execute()
        } fetch: {
            fetchSpokenLanguagesUseCase.execute()
        } delete: { id in
            try await deleteSpokenLanguageUseCase.execute(id)
        } add: { language in
            try await addSpokenLanguageUseCase.execute(language)
        } update: { language in
            try await updateSpokenLanguageUseCase.execute(language)
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
    } add: { language in
        fatalError("Unimplemented")
    } update: { language in
        fatalError("Unimplemented")
    }
}

extension LanguagesClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } fetch: {
        return .init { continuation in
            continuation.yield([])
            continuation.finish()
        }
    } delete: { id in
        
    } add: { language in
        
    } update: { language in
        
    }

}

public extension DependencyValues {

    var languagesClient: LanguagesClient {
        get { self[LanguagesClient.self] }
        set { self[LanguagesClient.self] = newValue }
    }
}
