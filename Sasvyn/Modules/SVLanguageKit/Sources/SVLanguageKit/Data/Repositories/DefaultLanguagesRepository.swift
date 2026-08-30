//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

final class DefaultLanguagesRepository: LanguagesRepository {
    
    private let dataSource: LanguagesLocalDataSource
    
    init(dataSource: LanguagesLocalDataSource) {
        self.dataSource = dataSource
    }
    
    func loadLanguagesJSON() async throws -> [Language] {
        try await dataSource.loadLanguagesJSON()
    }
    
    func fetch() async throws -> [SpokenLanguage] {
        let records = try await dataSource.fetch()
        return records.compactMap { SpokenLanguageRecordMapper.map($0) }
    }
    
    func add(_ language: SpokenLanguage) async throws {
        try await dataSource.create(language)
    }
    
    func update(_ language: SpokenLanguage) async throws {
        try await dataSource.update(language)
    }
    
    func delete(_ id: String) async throws {
        try await dataSource.delete(id: id)
    }
    
}
