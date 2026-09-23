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

public final class DefaultUsersRepository: UsersRepository {

    private let localDataSource: UsersLocalDataSource
    private let remoteDataSource: UsersRemoteDataSource
    private let tokenStore: any TokenStore
    private let imageUploader: any ImageUploader

    init(
        localDataSource: UsersLocalDataSource,
        remoteDataSource: UsersRemoteDataSource,
        tokenStore: any TokenStore,
        imageUploader: any ImageUploader
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
        self.imageUploader = imageUploader
    }

    public func fetchCurrentUser() async throws -> User {
        guard let userId = tokenStore.userId else {
            throw URLError(.unknown)
        }

        if let record = try await localDataSource.fetch(id: userId) {
            let user = UserRecordMapper.map(record)

            if record.profileSyncStatus != .synced {
                Task { [weak self] in
                    guard let self else { return }

                    do {
                        try await update(user)
                    } catch {
                        print("Profile sync failed:", error.localizedDescription)
                    }
                }
            }

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
            
            Task { [weak self] in
                guard let self else { return }

                if let syncedAt = record.syncedAt,
                   Date().timeIntervalSince(syncedAt) <= 60 {
                    return
                }
                
                guard record.profileSyncStatus == .synced,
                      record.imageSyncStatus == .synced else {
                    return
                }
                do {
                    let response = try await remoteDataSource.fetch(userId)
                    let serverUser = response.data

                    guard serverUser.updatedAt > record.updatedAt else {
                        return
                    }

                    try await localDataSource.save(
                        user: serverUser.toDomain(),
                        profileSyncStatus: .synced,
                        imageSyncStatus: .synced,
                        syncedAt: .now
                    )
                } catch {
                    print("Server sync failed:", error.localizedDescription)
                }
            }
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
        try await localDataSource.save(
            user: user,
            profileSyncStatus: .pending
        )

        let body = UpdateUserDTO(
            fullName: user.fullName,
            dateOfBirth: user.dateOfBirth?.formatted(.isoDate),
            imageKey: nil
        )

        let response = try await remoteDataSource.update(
            user.id,
            body: body
        )

        try await localDataSource.save(
            user: response.data.toDomain(),
            profileSyncStatus: .synced
        )
        
        try await localDataSource.updateSyncedAt(
            id: user.id,
            syncedAt: .now
        )
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
