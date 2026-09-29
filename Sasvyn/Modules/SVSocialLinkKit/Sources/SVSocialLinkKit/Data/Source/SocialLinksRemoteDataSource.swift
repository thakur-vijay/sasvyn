//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
import NetworkKit
import SVNetwork

final class SocialLinksRemoteDataSource: Sendable{
    private let client: any NetworkClientProtocol
    
    init(client: any NetworkClientProtocol) {
        self.client = client
    }
    
    func fetch() async throws-> ListResponseDTO<SocialLinkReponseDTO>{
        let endpoint = FetchSocialLinksEndpoint()
        return try await client.request(endpoint)
    }
    
    func add(_ body: CreateSocialLinkDTO) async throws {
        let endpoint = CreateSocialLinkEndpoint(body)
        try await client.request(endpoint)
    }
    
    func update(_ id: String, body: UpdateSocialLinkDTO) async throws {
        let endpoint = UpdateSocialLinkEndpoint(id, body: body)
        try await client.request(endpoint)
    }
    
    func delete(_ id: String) async throws {
        let endpoint = DeleteSocialLinkEndpoint(id)
        try await client.request(endpoint)
    }
}
