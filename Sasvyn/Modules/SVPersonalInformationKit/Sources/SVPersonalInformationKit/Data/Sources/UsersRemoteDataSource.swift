//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import NetworkKit
import SVNetwork
import SVSyncKit
import Foundation

internal final class UsersRemoteDataSource: SyncRemoteStore, Sendable{
    private let client: NetworkClientProtocol
    private let fileUploader: any FileUploader
    
    init(client: NetworkClientProtocol, fileUploader: any FileUploader) {
        self.client = client
        self.fileUploader = fileUploader
    }
    
    func fetch() async throws -> [User] {
        return []
    }
    
    func fetch(_ id: String) async throws-> DataResponseDTO<UserDTO>{
        let endpoint = FetchUserEndpoint(id: id)
        return try await request { try await client.request(endpoint) }
    }
    
    func update(_ id: String, body: UpdateUserDTO, idempotencyKey: String) async throws-> DataResponseDTO<UserDTO> {
        let endpoint = UpdateUserEndpoint(id: id, body: body, idempotencyKey: idempotencyKey)
        return try await request { try await client.request(endpoint) }
    }

    func fetch(id: String) async throws -> User? {
        try await fetch(id).data.toDomain()
    }

    func create(_ entity: User, idempotencyKey: String) async throws -> User {
        try await update(entity, idempotencyKey: idempotencyKey)
    }

    func update(
        _ entity: User,
        idempotencyKey: String
    ) async throws -> User {

        var imageKey: String?

        if let imageLocalUrl = entity.imageLocalUrl {
            let uploadBody = CreateUploadDTO(
                type: "profile_image",
                contentType: "image/jpeg"
            )

            imageKey = try await fileUploader.upload(
                uploadBody,
                fileURL: imageLocalUrl
            )
        }

        let body = UpdateUserDTO(
            fullName: entity.fullName,
            dateOfBirth: entity.dateOfBirth?.formatted(.isoDate),
            imageKey: imageKey
        )

        let response = try await update(
            entity.id,
            body: body,
            idempotencyKey: idempotencyKey
        )

        var updatedUser = response.data.toDomain()

        // Local-only URL is cleared only after successful server upload.
        updatedUser.imageLocalUrl = nil

        return updatedUser
    }

    func delete(id: String, idempotencyKey: String) async throws {
        throw SyncError.invalidState
    }

    private func request<Response: Codable & Hashable & Sendable>(
        _ operation: @Sendable () async throws -> Response
    ) async throws -> Response {
        do {
            return try await operation()
        } catch is CancellationError {
            throw SyncError.cancelled
        } catch let error as UsersRemoteError {
            throw error
        } catch {
            throw UsersRemoteError(
                message: String(describing: error),
                isRetryable: Self.isTransient(error)
            )
        }
    }

    private static func isTransient(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        switch urlError.code {
        case .cannotConnectToHost,
             .dnsLookupFailed,
             .networkConnectionLost,
             .notConnectedToInternet,
             .timedOut,
             .resourceUnavailable:
            return true
        default:
            return false
        }
    }

}

private struct UsersRemoteError: Error, Sendable, SyncRetryableError {
    let message: String
    let isRetryable: Bool
}
