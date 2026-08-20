//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct AddDocumentUseCase: Sendable {
    private let repository: DocumentsRepository
    
    init(repository: DocumentsRepository) {
        self.repository = repository
    }
    
    func execute(document: Document)async throws {
        try await repository.add(document: document)
    }
}
