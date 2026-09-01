//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

final class DefaultSocialLinksRepository: SocialLinksRepository {
   
    private let dataSource: SocialLinksLocalDataSource
    
    init(dataSource: SocialLinksLocalDataSource) {
        self.dataSource = dataSource
    }
    
    func fetch() async throws -> [SocialLink] {
       let records = try await dataSource.fetch()
        return records.compactMap { SocialLinkRecordMapper.map($0) }
    }
    
    func add(_ link: SocialLink) async throws {
        try await dataSource.create(link)
    }
    
    func update(_ link: SocialLink) async throws {
        try await dataSource.update(link)
    }
    
    func delete(_ id: String) async throws {
        try await dataSource.delete(id: id)
    }
    
}
