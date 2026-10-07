//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct FetchDocumentsUseCase: Sendable {
    private let repository: DocumentsRepository
    
    init(repository: DocumentsRepository) {
        self.repository = repository
    }
    
    func execute(category: DocumentCategory?)-> AsyncStream<[Document]>{
        repository.fetch(category: category)
    }
}
