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
    @Sendable (_ search: String) async throws -> [Project]
    
    public var fetchProject:
    @Sendable (_ id: String) async throws -> Project?

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ project: Project) async throws -> Void
    
    public var update:
    @Sendable (_ project: Project) async throws -> Void
    
    public var removeSkill:
    @Sendable (_ id: String, _ projectId: String) async throws -> Void
    
    public var deleteProjectScreenshot:
    @Sendable (_ id: String, _ projectId: String) async throws -> Void
}

extension ProjectsClient {

    static func live(
        fetchProjectsUseCase: FetchProjectsUseCase,
        fetchProjectUseCase: FetchProjectUseCase,
        addProjectUseCase: AddProjectUseCase,
        updateProjectUseCase: UpdateProjectUseCase,
        deleteProjectUseCase: DeleteProjectUseCase,
        removeSkillFromProjectUseCase: RemoveSkillFromProjectUseCase,
        deleteProjectScreenshotUseCase: DeleteProjectScreenshotUseCase
    ) -> Self {

        Self { search in
            try await fetchProjectsUseCase.execute(search: search)
        } fetchProject: { id in
            try await fetchProjectUseCase.execute(id: id)
        } delete: { id in
            try await deleteProjectUseCase.execute(id: id)
        } add: { project in
            try await addProjectUseCase.execute(project: project)
        } update: { project in
            try await updateProjectUseCase.execute(project: project)
        } removeSkill: { id, projectId in
            try await removeSkillFromProjectUseCase.execute(id: id, from: projectId)
        } deleteProjectScreenshot: { id, projectId in
            try await deleteProjectScreenshotUseCase.execute(id: id, projectID: projectId)
        }

    }
}

extension ProjectsClient: DependencyKey {

    public static let liveValue = Self { search in
        fatalError("Unimplemented")
    } fetchProject: { id in
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { project in
        fatalError("Unimplemented")
    } update: { project in
        fatalError("Unimplemented")
    } removeSkill: { id, projectId in
        fatalError("Unimplemented")
    } deleteProjectScreenshot: { id, projectId in
        fatalError("Unimplemented")
    }
    
}

extension ProjectsClient: TestDependencyKey {

    public static let testValue = Self { search in
        return []
    } fetchProject: { id in
        return nil
    } delete: { id in
        
    } add: { project in
        
    } update: { project in
        
    } removeSkill: { id, projectId in
        
    } deleteProjectScreenshot: { id, projectId in
        
    }
}

public extension DependencyValues {

    var projectsClient: ProjectsClient {
        get { self[ProjectsClient.self] }
        set { self[ProjectsClient.self] = newValue }
    }
}
