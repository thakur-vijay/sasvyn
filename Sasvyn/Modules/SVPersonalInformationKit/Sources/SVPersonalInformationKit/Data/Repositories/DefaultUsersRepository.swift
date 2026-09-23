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
        guard let userId = self.tokenStore.userId else {
            throw URLError(.unknown)
        }
        if let record = try await localDataSource.fetch(id: userId) {
            return UserRecordMapper.map(record)
        }else {
            let response = try await remoteDataSource.fetch(userId)
            let user = response.data.toDomain()
            try await localDataSource.save(user: user)
            return user
        }
    }
    
    public func update(_ user: User) async throws {
        try await localDataSource.save(user: user)
        let body = UpdateUserDTO(
            fullName: user.fullName,
            dateOfBirth: user.dateOfBirth?.formatted(.isoDate),
            imageKey: nil
        )
        let response = try await remoteDataSource.update(user.id, body: body)
        try await localDataSource.save(user: response.data.toDomain())
    }
    
    public func updateImage(_ user: User) async throws {
        guard let imageLocalUrl = user.imageLocalUrl else {
            throw URLError(.badURL)
        }
        try await localDataSource.save(user: user)

        let body = CreateUploadDTO(
            type: "profile_image",
            contentType: "image/jpeg"
        )

        let imageKey = try await imageUploader.upload(
            body,
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
        try await localDataSource.save(user: updatedUser)
    }
}
