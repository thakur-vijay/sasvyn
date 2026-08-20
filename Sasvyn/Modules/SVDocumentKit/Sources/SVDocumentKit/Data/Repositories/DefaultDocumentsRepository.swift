//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultDocumentsRepository: DocumentsRepository {

    private let dataSource: DocumentsLocalDataSource
    
    init(dataSource: DocumentsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(category: DocumentCategory?) async throws -> [Document] {
        let allDocuments = try await dataSource.fetch(category: category)
        let directory = try DocumentStorage.documentsDirectory()
        return allDocuments.compactMap { DocumentRecordMapper.map($0, documentsDirectory: directory)}
    }
    
    public func add(document: Document) async throws {
        try await dataSource.create(document: document)
    }
    
    public func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
