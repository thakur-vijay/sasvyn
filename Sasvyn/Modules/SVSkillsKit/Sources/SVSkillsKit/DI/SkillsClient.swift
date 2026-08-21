//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture

public struct SkillsClient: Sendable{
    public var fetch:
        @Sendable () async throws -> [SkillMainModel]

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ skills: [Skill]) async throws -> Void
}

extension SkillsClient {

    static func live(
        fetchSkillsUseCase: FetchSkillsUseCase,
        addSkillUseCase: AddSkillUseCase,
        deleteSkillUseCase: DeleteSkillUseCase,
    ) -> Self {

        Self {
            try await fetchSkillsUseCase.execute()
        } delete: { id in
            try await deleteSkillUseCase.execute(id: id)
        } add: { skills in
            try await addSkillUseCase.execute(skills: skills)
        }

    }
}

extension SkillsClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { skills in
        fatalError("Unimplemented")
    }
}

extension SkillsClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } add: { skills in
        
    }

}

public extension DependencyValues {

    var skillsClient: SkillsClient {
        get { self[SkillsClient.self] }
        set { self[SkillsClient.self] = newValue }
    }
}
