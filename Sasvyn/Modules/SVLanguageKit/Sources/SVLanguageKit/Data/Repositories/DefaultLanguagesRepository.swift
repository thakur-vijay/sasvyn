//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVSyncKit

final class DefaultLanguagesRepository: LanguagesRepository {
    
    private let dataSource: LanguagesLocalDataSource
    private let syncEngine: any SyncEngine<Language>
    
    init(dataSource: LanguagesLocalDataSource, syncEngine: any SyncEngine<Language>) {
        self.dataSource = dataSource
        self.syncEngine = syncEngine
    }
    
    func loadLanguagesJSON() async throws -> [Language] {
        try await dataSource.loadLanguagesJSON()
    }
    
    func fetch() async throws -> [SpokenLanguage] {
        let records = try await dataSource.fetch()
        return records.compactMap { $0.entity }
    }
    
    func save(_ language: SpokenLanguage) async throws {
//        try await dataSource.save(language)
    }
    
    func delete(_ id: String) async throws {
        try await dataSource.delete(id: id)
    }
    
}
