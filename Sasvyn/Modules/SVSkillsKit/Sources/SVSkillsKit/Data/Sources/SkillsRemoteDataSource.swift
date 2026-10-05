//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
import SVSyncKit
import NetworkKit

final class SkillsRemoteDataSource: SyncRemoteStore{
    
    private let client: any NetworkClientProtocol
    
    init(client: any NetworkClientProtocol) {
        self.client = client
    }

    func fetch() async throws -> [Skill] {
        let endpoint = FetchSkillsEndpoint()
        let result = try await client.request(endpoint)
        return result.data.compactMap { $0.toDomain() }
    }
    
    func fetch(id: String) async throws -> Skill? {
        do {
            let endpoint = FetchSkillEndpoint(id)
            let result = try await client.request(endpoint)
            return result.data.toDomain()
        }catch NetworkError.notFound {
            return nil
        }catch {
            throw error
        }
    }
    
    func create(_ entity: Skill, idempotencyKey: String) async throws -> Skill {
        let body = CreateSkillDTO(
            id: entity.id,
            skill: entity.skill,
            category: entity.category.rawValue,
        )
        let endpoint = CreateSkillEndpoint(
            body,
            idempotencyKey: idempotencyKey
        )
        
        let result = try await client.request(endpoint)
        return result.data.toDomain()
    }
    
    func update(_ entity: Skill, idempotencyKey: String) async throws -> Skill {
        let body = UpdateSkillDTO(
            skill: entity.skill,
            category: entity.category.rawValue,
        )
        let endpoint = UpdateSkillEndpoint(
            entity.id,
            body: body,
            idempotencyKey: idempotencyKey
        )
        
        let result = try await client.request(endpoint)
        return result.data.toDomain()
    }
    
    func delete(id: String, idempotencyKey: String) async throws {
        let endpoint = DeleteSkillEndpoint(id, idempotencyKey: idempotencyKey)
        try await client.request(endpoint)
    }
}
