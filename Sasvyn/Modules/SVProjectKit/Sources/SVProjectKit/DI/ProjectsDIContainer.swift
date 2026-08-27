//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class ProjectsDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: ProjectsLocalDataSource = {
        ProjectsLocalDataSource(database: database)
    }()

    private lazy var repository: ProjectsRepository = {
        DefaultProjectsRepository(dataSource: dataSource)
    }()
    
    private lazy var addProjectUseCase: AddProjectUseCase = {
        AddProjectUseCase(repository: repository)
    }()
    
    private lazy var updateProjectUseCase: UpdateProjectUseCase = {
        UpdateProjectUseCase(repository: repository)
    }()
    
    private lazy var fetchProjectsUseCase: FetchProjectsUseCase = {
        FetchProjectsUseCase(repository: repository)
    }()
    
    private lazy var deleteProjectUseCase: DeleteProjectUseCase = {
        DeleteProjectUseCase(repository: repository)
    }()
      
    private lazy var fetchProjectUseCase: FetchProjectUseCase = {
        FetchProjectUseCase(repository: repository)
    }()
    
    private lazy var removeSkillFromProjectUseCase: RemoveSkillFromProjectUseCase = {
        RemoveSkillFromProjectUseCase(repository: repository)
    }()
    
    private lazy var deleteProjectScreenshotsUseCase: DeleteProjectScreenshotsUseCase = {
        DeleteProjectScreenshotsUseCase(repository: repository)
    }()
    
    private lazy var addProjectScreenshotsUseCase: AddProjectScreenshotsUseCase = {
        AddProjectScreenshotsUseCase(repository: repository)
    }()
    
    private lazy var reorderProjectScreenshotsUseCase: ReorderProjectScreenshotsUseCase = {
        ReorderProjectScreenshotsUseCase(repository: repository)
    }()
    
    private lazy var client: ProjectsClient = {
        ProjectsClient.live(
            fetchProjectsUseCase: fetchProjectsUseCase,
            fetchProjectUseCase: fetchProjectUseCase,
            addProjectUseCase: addProjectUseCase,
            updateProjectUseCase: updateProjectUseCase,
            deleteProjectUseCase: deleteProjectUseCase,
            removeSkillFromProjectUseCase: removeSkillFromProjectUseCase,
            deleteProjectScreenshotsUseCase: deleteProjectScreenshotsUseCase,
            addProjectScreenshotsUseCase: addProjectScreenshotsUseCase,
            reorderProjectScreenshotsUseCase: reorderProjectScreenshotsUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.projectsClient = client
    }
    
}
