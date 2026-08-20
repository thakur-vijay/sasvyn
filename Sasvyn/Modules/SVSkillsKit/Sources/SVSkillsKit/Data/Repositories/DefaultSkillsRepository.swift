//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public final class DefaultSkillsRepository: SkillsRepository {

    private let dataSource: SkillsLocalDataSource
    
    init(dataSource: SkillsLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [SkillMainModel] {
        let allSkills = try await dataSource.fetch()

        return Dictionary(grouping: allSkills, by: \.category)
            .compactMap { category, records in
                guard let category = SkillCategory(rawValue: category) else {
                    return nil
                }

                return SkillMainModel(
                    category: category,
                    skills: records.compactMap(SkillRecordMapper.map)
                )
            }
            .sorted { $0.category.order < $1.category.order }
    }
    
    public func add(skills: [Skill]) async throws {
        try await dataSource.create(skills: skills)
    }
    
    public func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
    
}
