//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import Foundation
import SVSyncKit
import NetworkKit
import SVNetwork

final class DocumentsRemoteDataSource: SyncRemoteStore{
    
    private let client: any NetworkClientProtocol
    private let fileUploader: any FileUploader
    
    init(
        client: any NetworkClientProtocol,
        fileUploader: any FileUploader
    ) {
        self.client = client
        self.fileUploader = fileUploader
    }

    func fetch() async throws -> [Document] {
        let endpoint = FetchDocumentsEndpoint()
        let result = try await client.request(endpoint)
        return result.data.compactMap { $0.toDomain() }
    }
    
    func fetch(id: String) async throws -> Document? {
        do {
            let endpoint = FetchDocumentEndpoint(id)
            let result = try await client.request(endpoint)
            return result.data.toDomain()
        }catch NetworkError.notFound {
            return nil
        }catch {
            throw error
        }
    }
    
    func create(_ entity: Document, idempotencyKey: String) async throws -> Document {
        var documentKey: String?

        if let documentLocalUrl = entity.url {
            let uploadBody = CreateUploadDTO(
                type: "document",
                contentType: "application/pdf"
            )

            documentKey = try await fileUploader.upload(
                uploadBody,
                fileURL: documentLocalUrl
            )
        }
        guard let documentKey else { throw URLError(.fileDoesNotExist) }
        let body = CreateDocumentDTO(
            id: entity.id,
            name: entity.name,
            category: entity.category.rawValue,
            fileSize: entity.fileSize,
            key: documentKey
        )
        let endpoint = CreateDocumentEndpoint(
            body,
            idempotencyKey: idempotencyKey
        )
        
        let result = try await client.request(endpoint)
        return result.data.toDomain()
    }
    
    func update(_ entity: Document, idempotencyKey: String) async throws -> Document {
        return try await create(entity, idempotencyKey: idempotencyKey)
    }
    
    func delete(id: String, idempotencyKey: String) async throws {
        let endpoint = DeleteDocumentEndpoint(id, idempotencyKey: idempotencyKey)
        try await client.request(endpoint)
    }
    
    func fetchDocumentData(_ entity: Document) async throws {
        guard let endpoint = entity.url else { throw URLError(.badURL) }
    }
}
