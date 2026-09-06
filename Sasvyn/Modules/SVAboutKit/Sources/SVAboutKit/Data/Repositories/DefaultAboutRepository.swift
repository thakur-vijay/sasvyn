//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultAboutRepository: AboutRepository {

    private let dataSource: AboutLocalDataSource
    
    init(dataSource: AboutLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(_ userId: String) async throws -> About {
        guard let record = try await dataSource.fetch(userId) else {
            throw URLError(.fileDoesNotExist)
        }
        return AboutRecordMapper.map(record)
    }
    
    public func save(_ about: About) async throws {
        try await dataSource.save(about: about)
    }
}
