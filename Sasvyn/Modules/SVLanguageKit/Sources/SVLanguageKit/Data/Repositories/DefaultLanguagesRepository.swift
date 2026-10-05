//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVSyncKit

final class DefaultLanguagesRepository: LanguagesRepository {
    
    private let localDataSource: LanguagesLocalDataSource
    private let remoteDataSource: LanguagesRemoteDataSource
    private let syncEngine: any SyncEngine<SpokenLanguage>
    
    init(
        localDataSource: LanguagesLocalDataSource,
        remoteDataSource: LanguagesRemoteDataSource,
        syncEngine: any SyncEngine<SpokenLanguage>
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.syncEngine = syncEngine
    }
    
    func loadLanguagesJSON() async throws -> [Language] {
        try await localDataSource.loadLanguagesJSON()
    }
    
    func fetch() -> AsyncStream<[SpokenLanguage]> {
        AsyncStream { continuation in
            let task = Task {
                do {
                    let localLanguages = try await localDataSource.fetch()
                    continuation.yield(
                        localLanguages.compactMap { $0.entity }
                    )

                    // 2. Sync with server
                    let result = try await syncEngine.sync()

                    // 3. Emit synced result if anything changed
                    switch result {
                    case .noChange:
                        break

                    case .downloaded(let list),
                         .uploaded(let list),
                         .conflictResolved(let list):
                        continuation.yield(list)
                    }

                    continuation.finish()

                } catch {
                    dump(error)
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    func add(_ link: SpokenLanguage) async throws {
        try await localDataSource.create(link)
        try await syncEngine.enqueue(id: link.id, operation: .create)
        Task {
            try? await syncEngine.sync(id: link.id)
        }
    }
    
    func update(_ link: SpokenLanguage) async throws {
        try await localDataSource.update(link)
        try await syncEngine.enqueue(id: link.id, operation: .update)
        Task {
            try? await syncEngine.sync(id: link.id)
        }
    }
    
    func delete(_ id: String) async throws {
        try await localDataSource.delete(id: id)
        try await syncEngine.enqueue(id: id, operation: .delete)
        Task {
            try? await syncEngine.sync(id: id)
        }
    }
}
