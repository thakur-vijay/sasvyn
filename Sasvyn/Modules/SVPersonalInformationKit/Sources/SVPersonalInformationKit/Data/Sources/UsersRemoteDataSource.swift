//
//  File.swift
//  SVPersonalInformationKit
//
//  Created by Vijay Thakur on 21/09/26.
//

import NetworkKit
import SVNetwork

internal final class UsersRemoteDataSource: Sendable{
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func fetch(_ id: String) async throws-> DataResponseDTO<UserDTO>{
        let endpoint = FetchUserEndpoint(id: id)
        return try await client.request(endpoint)
    }
    
    func update(_ id: String, body: UpdateUserDTO) async throws-> DataResponseDTO<UserDTO> {
        let endpoint = UpdateUserEndpoint(id: id, body: body)
        return try await client.request(endpoint)
    }
    
    func upload(_ body: CreateUploadDTO) async throws -> DataResponseDTO<UploadDTO> {
        let endpoint = UploadEndpoint(body)
        return try await client.request(endpoint)
    }
}
