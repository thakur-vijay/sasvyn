//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation
import SVSyncKit

public final class DefaultSkillsRepository: SkillsRepository {

    private let localDataSource: SkillsLocalDataSource
    private let remoteDataSource: SkillsRemoteDataSource
    private let syncEngine: any SyncEngine<Skill>
    
    init(localDataSource: SkillsLocalDataSource, remoteDataSource: SkillsRemoteDataSource, syncEngine: any SyncEngine<Skill>) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.syncEngine = syncEngine
    }
    
    public func fetch() -> AsyncStream<[SkillMainModel]> {
        AsyncStream { continuation in
            let task = Task {
                do {
                    let allSkills = try await localDataSource.fetch().compactMap { $0.entity }
                    continuation.yield(group(allSkills))
                    
                    let result = try await syncEngine.sync()
                    
                    switch result {
                    case .noChange:
                        break

                    case .downloaded(let list),
                         .uploaded(let list),
                         .conflictResolved(let list):
                        continuation.yield(group(list))
                    }

                    continuation.finish()
                }catch {
                    dump(error)
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
    
    
//    public func fetch() async throws -> [SkillMainModel] {
//        let allSkills = try await localDataSource.fetch().compactMap { $0.entity }
//
//        return Dictionary(grouping: allSkills, by: \.category)
//            .compactMap { category, skills in
//                return SkillMainModel(
//                    category: category,
//                    skills: skills
//                )
//            }
//            .sorted { $0.category.order < $1.category.order }
//    }
    
    public func add(skill: Skill) async throws {
        try await localDataSource.create(skill)
        try await syncEngine.enqueue(id: skill.id, operation: .create)
        Task {
            try? await syncEngine.sync(id: skill.id)
        }
    }
    
    public func update(skill: Skill) async throws {
        try await localDataSource.update(skill)
        try await syncEngine.enqueue(id: skill.id, operation: .update)
        Task {
            try? await syncEngine.sync(id: skill.id)
        }
    }
    
    public func delete(id: String) async throws {
        try await localDataSource.delete(id: id)
        try await syncEngine.enqueue(id: id, operation: .delete)
        Task {
            try? await syncEngine.sync(id: id)
        }
    }
    
    private func group(_ list: [Skill]) -> [SkillMainModel] {
        return Dictionary(grouping: list, by: \.category)
            .compactMap { category, skills in
                return SkillMainModel(
                    category: category,
                    skills: skills
                )
            }
            .sorted { $0.category.order < $1.category.order }
    }
    
}
