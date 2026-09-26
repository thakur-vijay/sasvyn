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

//            if record.syncStatus != .synced {
//                Task { [weak self] in
//                    guard let self else { return }
//
//                    do {
//                        try await updateImage(user)
//                    } catch {
//                        print("Image sync failed:", error.localizedDescription)
//                    }
//                }
//            }

            Task { [syncEngine] in
                _ = try? await syncEngine.sync(id: userId)
            }

            return user
        }

        let response = try await remoteDataSource.fetch(userId)
        let user = response.data.toDomain()

        try await localDataSource.create(user)

        return user
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
        guard let imageLocalUrl = user.imageLocalUrl else {
            throw URLError(.badURL)
        }

        try await localDataSource.update(user)

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
            body: updateBody,
            idempotencyKey: UUID().uuidString
        )

        var updatedUser = user
        updatedUser.imageUrl = response.data.imgUrl

        try await localDataSource.update(updatedUser)
    }
}
