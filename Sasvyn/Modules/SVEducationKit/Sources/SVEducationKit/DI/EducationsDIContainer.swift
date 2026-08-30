//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class EducationsDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: EducationsLocalDataSource = {
        EducationsLocalDataSource(database: database)
    }()

    private lazy var repository: EducationsRepository = {
        DefaultEducationsRepository(dataSource: dataSource)
    }()
    
    private lazy var addEducationUseCase: AddEducationUseCase = {
        AddEducationUseCase(repository: repository)
    }()
    
    private lazy var fetchEducationsUseCase: FetchEducationsUseCase = {
        FetchEducationsUseCase(repository: repository)
    }()
    
    private lazy var deleteEducationUseCase: DeleteEducationUseCase = {
        DeleteEducationUseCase(repository: repository)
    }()
    
    private lazy var updateEducationUseCase: UpdateEducationUseCase = {
        UpdateEducationUseCase(repository: repository)
    }()
    
    private lazy var client: EducationsClient = {
        EducationsClient.live(
            fetchEducationsUseCase: fetchEducationsUseCase,
            addEducationUseCase: addEducationUseCase,
            updateEducationUseCase: updateEducationUseCase,
            deleteEducationUseCase: deleteEducationUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.educationsClient = client
    }
    
}
