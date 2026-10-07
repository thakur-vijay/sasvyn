//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import Foundation

internal struct DocumentResponseDTO: Codable, Hashable, Sendable {
    let id: String
    let userId: String
    let name: String
    let category: String
    let fileSize: Int64
    let url: String
    let syncVersion: Int64
    let createdAt: Date
    let updatedAt: Date
}

internal extension DocumentResponseDTO {
    func toDomain()-> Document {
        .init(
            id: id,
            url: .init(string: url),
            name: name,
            createdAt: createdAt,
            fileSize: fileSize,
            category: DocumentCategory(rawValue: category) ?? .other,
            syncVersion: syncVersion,
            updatedAt: updatedAt
        )
    }
}
