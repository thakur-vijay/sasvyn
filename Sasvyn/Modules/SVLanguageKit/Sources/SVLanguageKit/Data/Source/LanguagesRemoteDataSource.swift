//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation
import SVSyncKit
import NetworkKit

final class LanguagesRemoteDataSource: SyncRemoteStore{
    
    private let client: any NetworkClientProtocol
    
    init(client: any NetworkClientProtocol) {
        self.client = client
    }

    func fetch() async throws -> [SpokenLanguage] {
        let endpoint = FetchLanguagesEndpoint()
        let result = try await client.request(endpoint)
        return result.data.compactMap { $0.toDomain() }
    }
    
    func fetch(id: String) async throws -> SpokenLanguage? {
        do {
            let endpoint = FetchLanguageEndpoint(id)
            let result = try await client.request(endpoint)
            return result.data.toDomain()
        }catch NetworkError.notFound {
            return nil
        }catch {
            throw error
        }
    }
    
    func create(_ entity: SpokenLanguage, idempotencyKey: String) async throws -> SpokenLanguage {
        let body = CreateLanguageDTO(
            id: entity.id,
            languageCode: entity.languageCode,
            language: entity.language,
            proficiency: entity.proficiency.rawValue
        )
        let endpoint = CreateLanguageEndpoint(
            body,
            idempotencyKey: idempotencyKey
        )
        
        let result = try await client.request(endpoint)
        return result.data.toDomain()
    }
    
    func update(_ entity: SpokenLanguage, idempotencyKey: String) async throws -> SpokenLanguage {
        let body = UpdateLanguageDTO(
            languageCode: entity.languageCode,
            language: entity.language,
            proficiency: entity.proficiency.rawValue
        )
        let endpoint = UpdateLanguageEndpoint(
            entity.id,
            body: body,
            idempotencyKey: idempotencyKey
        )
        
        let result = try await client.request(endpoint)
        return result.data.toDomain()
    }
    
    func delete(id: String, idempotencyKey: String) async throws {
        let endpoint = DeleteLanguageEndpoint(id, idempotencyKey: idempotencyKey)
        try await client.request(endpoint)
    }
}
