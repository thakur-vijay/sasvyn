//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultMockupsRepository: MockupsRepository {

    private let dataSource: MockupsLocalDataSource
    
    init(dataSource: MockupsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [MockupModel] {
        let records = try await dataSource.fetch()
        let mockupsDirectory = try MockupStorage.mockupsDirectory()
        return records.compactMap { MockupRecordMapper.map($0, mockupsDirectory: mockupsDirectory)}
    }
    
    public func add(mockup: MockupModel) async throws {
        try await dataSource.create(mockup: mockup)
    }
    
    public func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
