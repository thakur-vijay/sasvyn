//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct DeleteDocumentUseCase: Sendable {
    private let repository: DocumentsRepository
    
    init(repository: DocumentsRepository) {
        self.repository = repository
    }
    
    func execute(id: String)async throws {
        try await repository.delete(id: id)
    }
}
