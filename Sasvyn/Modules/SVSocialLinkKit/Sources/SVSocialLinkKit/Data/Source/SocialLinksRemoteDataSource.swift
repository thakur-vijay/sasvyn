//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
import NetworkKit
import SVNetwork
import SVSyncKit

final class SocialLinksRemoteDataSource: SyncRemoteStore, Sendable{

    
    private let client: any NetworkClientProtocol
    
    init(client: any NetworkClientProtocol) {
        self.client = client
    }
    
    func fetch() async throws-> [SocialLink]{
        let endpoint = FetchSocialLinksEndpoint()
        let result = try await client.request(endpoint)
        return result.data.compactMap { SocialLinkDTOMapper.map($0) }
    }
    
    func fetch(id: String) async throws -> SocialLink? {
        do {
            let endpoint = FetchSocialLinkEndpoint(id)
            let result = try await client.request(endpoint)
            return SocialLinkDTOMapper.map(result.data)
        }catch NetworkError.notFound{
            return nil
        }catch {
            throw error
        }
    }
    
    func create(_ entity: SocialLink, idempotencyKey: String) async throws-> SocialLink{
        let body = CreateSocialLinkDTO(
            id: entity.id,
            type: entity.type?.rawValue ?? "",
            url: entity.url?.absoluteString ?? ""
        )
        let endpoint = CreateSocialLinkEndpoint(body, idempotencyKey: idempotencyKey)
        let result = try await client.request(endpoint)
        return SocialLinkDTOMapper.map(result.data)
    }
    
    func update(_ entity: SocialLink, idempotencyKey: String) async throws-> SocialLink{
        let body = UpdateSocialLinkDTO(type: entity.type?.rawValue ?? "", url: entity.url?.absoluteString ?? "")
        let endpoint = UpdateSocialLinkEndpoint(entity.id, body: body, idempotencyKey: idempotencyKey)
        let result = try await client.request(endpoint)
        return SocialLinkDTOMapper.map(result.data)
    }
    
    func delete(id: String, idempotencyKey: String) async throws {
        let endpoint = DeleteSocialLinkEndpoint(id, idempotencyKey: idempotencyKey)
        try await client.request(endpoint)
    }
}
