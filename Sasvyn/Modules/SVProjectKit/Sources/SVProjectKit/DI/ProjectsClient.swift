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
    
    public var fetchRecent:
    @Sendable (_ limit: Int) async throws -> [Project]
    
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
    
    public var deleteScreenshots:
    @Sendable (_ screenshots: [ProjectScreenshot]) async throws -> Void
    
    public var addScreenshots:
    @Sendable (_ screenshots: [ProjectScreenshot], _ projectID: String) async throws -> Void
    
    public var reorderScreenshots:
    @Sendable (_ screenshots: [ProjectScreenshot]) async throws -> Void
}

extension ProjectsClient {

    static func live(
        fetchProjectsUseCase: FetchProjectsUseCase,
        fetchRecentProjectsUseCase: FetchRecentProjectsUseCase,
        fetchProjectUseCase: FetchProjectUseCase,
        addProjectUseCase: AddProjectUseCase,
        updateProjectUseCase: UpdateProjectUseCase,
        deleteProjectUseCase: DeleteProjectUseCase,
        removeSkillFromProjectUseCase: RemoveSkillFromProjectUseCase,
        deleteProjectScreenshotsUseCase: DeleteProjectScreenshotsUseCase,
        addProjectScreenshotsUseCase: AddProjectScreenshotsUseCase,
        reorderProjectScreenshotsUseCase: ReorderProjectScreenshotsUseCase
    ) -> Self {

        Self { search in
            try await fetchProjectsUseCase.execute(search: search)
        } fetchRecent: { limit in
            try await fetchRecentProjectsUseCase.execute(limit: limit)
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
        } deleteScreenshots: { screenshots in
            try await deleteProjectScreenshotsUseCase.execute(screenshots: screenshots)
        } addScreenshots: { screenshots, projectID in
            try await addProjectScreenshotsUseCase.execute(screenshots: screenshots, projectID: projectID)
        } reorderScreenshots: { screenshots in
            try await reorderProjectScreenshotsUseCase.execute(screenshots: screenshots)
        }

    }
}

extension ProjectsClient: DependencyKey {

    public static let liveValue = Self { search in
        fatalError("Unimplemented")
    } fetchRecent: { limit in
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
    } deleteScreenshots: { screenshots in
        fatalError("Unimplemented")
    } addScreenshots: { screenshots, projectID in
        fatalError("Unimplemented")
    } reorderScreenshots: { screenshots in
        fatalError("Unimplemented")
    }
}

extension ProjectsClient: TestDependencyKey {

    public static let testValue = Self { search in
        return []
    } fetchRecent: { limit in
        return []
    } fetchProject: { id in
        return nil
    } delete: { id in
        
    } add: { project in
        
    } update: { project in
        
    } removeSkill: { id, projectId in
        
    } deleteScreenshots: { screenshots in
        
    } addScreenshots: { screenshots, projectID in
        
    } reorderScreenshots: { screenshots in
        
    }
}

public extension DependencyValues {

    var projectsClient: ProjectsClient {
        get { self[ProjectsClient.self] }
        set { self[ProjectsClient.self] = newValue }
    }
}
