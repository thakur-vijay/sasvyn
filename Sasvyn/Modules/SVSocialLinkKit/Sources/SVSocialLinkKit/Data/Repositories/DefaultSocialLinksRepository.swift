//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation
import SVSyncKit

internal final class DefaultSocialLinksRepository: SocialLinksRepository {
   
    private let localDataSource: SocialLinksLocalDataSource
    private let remoteDataSource: SocialLinksRemoteDataSource
    private let syncEngine: any SyncEngine<SocialLink>
    
    init(
        localDataSource: SocialLinksLocalDataSource,
        remoteDataSource: SocialLinksRemoteDataSource,
        syncEngine: any SyncEngine<SocialLink>
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.syncEngine = syncEngine
    }
    
    func fetch() -> AsyncStream<[SocialLink]> {
        AsyncStream { continuation in
            Task {
                do {
                    // 1. Emit local data immediately
                    let localLinks = try await localDataSource.fetch()
                    continuation.yield(
                        localLinks.compactMap { $0.entity }
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
        }
    }
    
    func add(_ link: SocialLink) async throws {
        try await localDataSource.create(link)
        try await syncEngine.enqueue(id: link.id, operation: .create)
        Task {
            try? await syncEngine.sync(id: link.id)
        }
    }
    
    func update(_ link: SocialLink) async throws {
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
