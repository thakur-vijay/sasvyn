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
    private let imageUploader: any ImageUploader
    private let syncEngine: any SyncEngine<User>

    init(
        localDataSource: UsersLocalDataSource,
        remoteDataSource: UsersRemoteDataSource,
        tokenStore: any TokenStore,
        imageUploader: any ImageUploader,
        syncEngine: any SyncEngine<User>
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
        self.imageUploader = imageUploader
        self.syncEngine = syncEngine
    }

    public func fetchCurrentUser() async throws -> User {
        guard let userId = tokenStore.userId else {
            throw URLError(.unknown)
        }

        if let record = try await localDataSource.fetchRecord(id: userId) {
            let user = UserRecordMapper.map(record)

            if record.imageSyncStatus != .synced {
                Task { [weak self] in
                    guard let self else { return }

                    do {
                        try await updateImage(user)
                    } catch {
                        print("Image sync failed:", error.localizedDescription)
                    }
                }
            }
            
            Task { [syncEngine] in _ = try? await syncEngine.sync(id: userId) }
            return user
        }

        let response = try await remoteDataSource.fetch(userId)
        let user = response.data.toDomain()

        try await localDataSource.save(
            user: user,
            profileSyncStatus: .synced,
            imageSyncStatus: .synced,
            syncedAt: .now
        )

        return user
    }

    public func update(_ user: User) async throws {
        print(user.fullName)
        var pendingUser = user
        pendingUser.updatedAt = .now
        try await localDataSource.save(
            user: pendingUser
        )
        try await syncEngine.enqueue(
            id: pendingUser.id,
            operation: .update
        )
        _ = try await syncEngine.sync(id: pendingUser.id)
    }

    public func updateImage(_ user: User) async throws {
        guard let imageLocalUrl = user.imageLocalUrl else {
            throw URLError(.badURL)
        }

        try await localDataSource.save(
            user: user,
            imageSyncStatus: .pending
        )

        let uploadBody = CreateUploadDTO(
            type: "profile_image",
            contentType: "image/jpeg"
        )

        let imageKey = try await imageUploader.upload(
            uploadBody,
            fileURL: imageLocalUrl
        )

        let updateBody = UpdateUserDTO(
            fullName: nil,
            dateOfBirth: nil,
            imageKey: imageKey
        )

        let response = try await remoteDataSource.update(
            user.id,
            body: updateBody
        )

        var updatedUser = user
        updatedUser.imageUrl = response.data.imgUrl

        try await localDataSource.save(
            user: updatedUser,
            imageSyncStatus: .synced
        )
        
        try await localDataSource.updateSyncedAt(
            id: user.id,
            syncedAt: .now
        )
    }
}
