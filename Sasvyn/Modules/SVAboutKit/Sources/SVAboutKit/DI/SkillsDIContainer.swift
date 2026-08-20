//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class SkillsDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: SkillsLocalDataSource = {
        SkillsLocalDataSource(database: database)
    }()

    private lazy var repository: SkillsRepository = {
        DefaultSkillsRepository(dataSource: dataSource)
    }()
    
    private lazy var addSkillUseCase: AddSkillUseCase = {
        AddSkillUseCase(repository: repository)
    }()
    
    private lazy var fetchSkillsUseCase: FetchSkillsUseCase = {
        FetchSkillsUseCase(repository: repository)
    }()
    
    private lazy var deleteSkillUseCase: DeleteSkillUseCase = {
        DeleteSkillUseCase(repository: repository)
    }()
    
    private lazy var client: SkillsClient = {
        SkillsClient.live(
            fetchSkillsUseCase: fetchSkillsUseCase,
            addSkillUseCase: addSkillUseCase,
            deleteSkillUseCase: deleteSkillUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.skillsClient = client
    }
    
}
