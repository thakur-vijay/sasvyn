//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct ProjectsClient: Sendable{
    public var fetch:
        @Sendable () async throws -> [Project]

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ project: Project) async throws -> Void
    
    public var update:
    @Sendable (_ project: Project) async throws -> Void
}

extension ProjectsClient {

    static func live(
        fetchProjectsUseCase: FetchProjectsUseCase,
        addProjectUseCase: AddProjectUseCase,
        updateProjectUseCase: UpdateProjectUseCase,
        deleteProjectUseCase: DeleteProjectUseCase,
    ) -> Self {

        Self {
            try await fetchProjectsUseCase.execute()
        } delete: { id in
            try await deleteProjectUseCase.execute(id: id)
        } add: { project in
            try await addProjectUseCase.execute(project: project)
        } update: { project in
            try await updateProjectUseCase.execute(project: project)
        }

    }
}

extension ProjectsClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { project in
        fatalError("Unimplemented")
    } update: { project in
        fatalError("Unimplemented")
    }
    
}

extension ProjectsClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } add: { project in
        
    } update: { project in
        
    }
}

public extension DependencyValues {

    var projectsClient: ProjectsClient {
        get { self[ProjectsClient.self] }
        set { self[ProjectsClient.self] = newValue }
    }
}
