//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultEducationsRepository: EducationsRepository {

    private let dataSource: EducationsLocalDataSource
    
    init(dataSource: EducationsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [Education] {
        let educationRecords = try await dataSource.fetch()
        return educationRecords.compactMap { EducationRecordMapper.map($0) }
    }
    
    public func add(_ education: Education) async throws {
        try await dataSource.create(education)
    }
    
    public func update(_ education: Education) async throws {
        try await dataSource.update(education)
    }
    
    public func delete(_ id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
