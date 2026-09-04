//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class MockupsDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: MockupsLocalDataSource = {
        MockupsLocalDataSource(database: database)
    }()

    private lazy var repository: MockupsRepository = {
        DefaultMockupsRepository(dataSource: dataSource)
    }()
    
    private lazy var addMockupUseCase: AddMockupUseCase = {
        AddMockupUseCase(repository: repository)
    }()
    
    private lazy var fetchMockupsUseCase: FetchMockupsUseCase = {
        FetchMockupsUseCase(repository: repository)
    }()
    
    private lazy var deleteMockupUseCase: DeleteMockupUseCase = {
        DeleteMockupUseCase(repository: repository)
    }()
    
    private lazy var client: MockupsClient = {
        MockupsClient.live(
            fetchMockupsUseCase: fetchMockupsUseCase,
            addMockupUseCase: addMockupUseCase,
            deleteMockupUseCase: deleteMockupUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.mockupsClient = client
        values.photosClient = PhotosClient.liveValue
    }
    
}
