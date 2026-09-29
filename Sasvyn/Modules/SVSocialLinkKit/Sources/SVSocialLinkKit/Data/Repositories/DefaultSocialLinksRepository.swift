//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

internal final class DefaultSocialLinksRepository: SocialLinksRepository {
   
    private let localDataSource: SocialLinksLocalDataSource
    private let remoteDataSource: SocialLinksRemoteDataSource
    
    init(localDataSource: SocialLinksLocalDataSource, remoteDataSource: SocialLinksRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func fetch() async throws -> [SocialLink] {
        let records = try await localDataSource.fetch()
        return records.compactMap { SocialLinkRecordMapper.map($0) }
    }
    
    func add(_ link: SocialLink) async throws {
        guard let type = link.type?.rawValue, let urlString = link.url?.absoluteString else {
            throw URLError(
                .cannotParseResponse
            )
        }
        try await localDataSource.create(link)
        try await remoteDataSource.add(.init(type: type, url: urlString))
    }
    
    func update(_ link: SocialLink) async throws {
        guard let type = link.type?.rawValue, let urlString = link.url?.absoluteString else {
            throw URLError(
                .cannotParseResponse
            )
        }
        try await localDataSource.update(link)
        try await remoteDataSource.update(
            link.id,
            body: .init(
                type: type,
                url: urlString
            )
        )
    }
    
    func delete(_ id: String) async throws {
        try await localDataSource.delete(id: id)
        try await remoteDataSource.delete(id)
    }
    
}
