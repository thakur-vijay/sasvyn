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
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func fetch(_ id: String) async throws-> DataResponseDTO<UserDTO>{
        let endpoint = FetchUserEndpoint(id: id)
        return try await request { try await client.request(endpoint) }
    }
    
    func update(_ id: String, body: UpdateUserDTO) async throws-> DataResponseDTO<UserDTO> {
        let endpoint = UpdateUserEndpoint(id: id, body: body)
        return try await request { try await client.request(endpoint) }
    }

    func fetch(id: String) async throws -> User? {
        try await fetch(id).data.toDomain()
    }

    func create(_ entity: User, idempotencyKey: String) async throws -> User {
        try await update(entity, idempotencyKey: idempotencyKey)
    }

    func update(_ entity: User, idempotencyKey: String) async throws -> User {
        let body = UpdateUserDTO(
            fullName: entity.fullName,
            dateOfBirth: entity.dateOfBirth?.formatted(.isoDate),
            imageKey: nil
        )
        return try await update(entity.id, body: body).data.toDomain()
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
