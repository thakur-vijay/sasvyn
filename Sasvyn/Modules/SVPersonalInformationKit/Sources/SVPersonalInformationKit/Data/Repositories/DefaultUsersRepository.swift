//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import NetworkKit
import SVFoundation
import SVNetwork
import SVSyncKit

public final class DefaultUsersRepository: UsersRepository {

    private let localDataSource: UsersLocalDataSource
    private let remoteDataSource: UsersRemoteDataSource
    private let tokenStore: any TokenStore
    private let syncEngine: any SyncEngine<User>

    init(
        localDataSource: UsersLocalDataSource,
        remoteDataSource: UsersRemoteDataSource,
        tokenStore: any TokenStore,
        syncEngine: any SyncEngine<User>
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
        self.syncEngine = syncEngine
    }
    
    public func fetchCurrentUser() -> AsyncStream<User> {
        AsyncStream { continuation in
            Task {
                guard let userId = tokenStore.userId else {
                    continuation.finish()
                    return
                }

                if let user = try? await localDataSource.fetch(id: userId) {
                    continuation.yield(user)

                    do {
                        let result = try await syncEngine.sync(id: userId)

                        switch result {
                        case .noChange:
                            print("There is no change")
                            break

                        case .downloaded(let user),
                             .uploaded(let user),
                             .conflictResolved(let user):
                            continuation.yield(user)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }

                    continuation.finish()
                    return
                }

                do {
                    let response = try await remoteDataSource.fetch(userId)
                    let user = response.data.toDomain()

                    try await localDataSource.create(user)
                    try await localDataSource.saveMetadata(
                        .init(
                            id: user.id,
                            entityType: "user",
                            state: .synced(version: user.syncVersion),
                            serverVersion: user.serverVersion,
                            lastSyncedAt: .now
                        )
                    )

                    continuation.yield(user)
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    public func update(_ user: User) async throws {
        try await localDataSource.update(user)
        try await syncEngine.enqueue(
            id: user.id,
            operation: .update
        )
        _ = try await syncEngine.sync(id: user.id)
    }
    
    public func updateImage(_ user: User) async throws {
        guard user.imageLocalUrl != nil else {
            throw URLError(.badURL)
        }

        try await localDataSource.update(user)

        try await syncEngine.enqueue(
            id: user.id,
            operation: .update
        )

        _ = try await syncEngine.sync(id: user.id)
    }
}
