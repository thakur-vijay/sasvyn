//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class LanguagesDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: LanguagesLocalDataSource = {
        LanguagesLocalDataSource(database: database)
    }()

    private lazy var repository: LanguagesRepository = {
        DefaultLanguagesRepository(dataSource: dataSource)
    }()
    
    private lazy var loadLanguagesJSONUseCase: LoadLanguagesJSONUseCase = {
        LoadLanguagesJSONUseCase(repository: repository)
    }()
    
    private lazy var fetchSpokenLanguagesUseCase: FetchSpokenLanguagesUseCase = {
        FetchSpokenLanguagesUseCase(repository: repository)
    }()
    
    private lazy var addSpokenLanguageUseCase: AddSpokenLanguageUseCase = {
        AddSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var updateSpokenLanguageUseCase: UpdateSpokenLanguageUseCase = {
        UpdateSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var deleteSpokenLanguageUseCase: DeleteSpokenLanguageUseCase = {
        DeleteSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var client: LanguagesClient = {
        LanguagesClient.live(
            loadLanguagesJSONUseCase: loadLanguagesJSONUseCase,
            fetchSpokenLanguagesUseCase: fetchSpokenLanguagesUseCase,
            addSpokenLanguageUseCase: addSpokenLanguageUseCase,
            updateSpokenLanguageUseCase: updateSpokenLanguageUseCase,
            deleteSpokenLanguageUseCase: deleteSpokenLanguageUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.languagesClient = client
    }
    
}
