//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class AboutDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: AboutLocalDataSource = {
        AboutLocalDataSource(database: database)
    }()

    private lazy var repository: AboutRepository = {
        DefaultAboutRepository(dataSource: dataSource)
    }()
    
    private lazy var fetchAboutUseCase: FetchAboutUseCase = {
        FetchAboutUseCase(repository: repository)
    }()
    
    private lazy var updateAboutUseCase: UpdateAboutUseCase = {
        UpdateAboutUseCase(repository: repository)
    }()

    private lazy var client: AboutClient = {
        AboutClient.live(
            fetchAboutUseCase: fetchAboutUseCase,
            saveAboutUseCase: updateAboutUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.aboutClient = client
    }
    
}
