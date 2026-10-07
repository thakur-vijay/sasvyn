//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSyncKit

public final class DefaultDocumentsRepository: DocumentsRepository {

    private let localDataSource: DocumentsLocalDataSource
    private let remoteDataSource: DocumentsRemoteDataSource
    private let syncEngine: any SyncEngine<Document>
    
    init(
        localDataSource: DocumentsLocalDataSource,
        remoteDataSource: DocumentsRemoteDataSource,
        syncEngine: any SyncEngine<Document>
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.syncEngine = syncEngine
    }
    
    public func fetch(category: DocumentCategory?) -> AsyncStream<[Document]> {
        AsyncStream { continuation in
            let task = Task {
                do {
                    let allDocuments = try await localDataSource.fetch().compactMap { $0.entity }
                    continuation.yield(allDocuments)
                    
                    let result = try await syncEngine.sync()
                    
                    switch result {
                    case .noChange:
                        break

                    case .downloaded(let list),
                         .uploaded(let list),
                         .conflictResolved(let list):
                        continuation.yield(list)
                    }

                    continuation.finish()
                }catch {
                    dump(error)
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
    
    public func add(document: Document) async throws {
        try await localDataSource.create(document)
        try await syncEngine.enqueue(id: document.id, operation: .create)
        Task {
            try? await syncEngine.sync(id: document.id)
        }
    }
    
    public func delete(id: String) async throws {
        try await localDataSource.delete(id: id)
        try await syncEngine.enqueue(id: id, operation: .delete)
        Task {
            try? await syncEngine.sync(id: id)
        }
    }

    
}
