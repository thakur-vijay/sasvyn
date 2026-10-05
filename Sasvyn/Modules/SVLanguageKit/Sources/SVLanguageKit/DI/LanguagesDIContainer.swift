//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 26.0, macOS 15.0, *)
public final class LanguagesDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: LanguagesLocalDataSource = {
        LanguagesLocalDataSource(database: database)
    }()
    
    private final class TestRepo: LanguagesRepository {
        func loadLanguagesJSON() async throws -> [Language] {
            return []
        }
        
        func fetch() async throws -> [SpokenLanguage] {
            return []
        }
        
        func save(_ language: SpokenLanguage) async throws {
            
        }
        
        func delete(_ id: String) async throws {
            
        }
        
        
    }

    private lazy var repository: LanguagesRepository = {
        TestRepo()
    }()
    
    private lazy var loadLanguagesJSONUseCase: LoadLanguagesJSONUseCase = {
        LoadLanguagesJSONUseCase(repository: repository)
    }()
    
    private lazy var fetchSpokenLanguagesUseCase: FetchSpokenLanguagesUseCase = {
        FetchSpokenLanguagesUseCase(repository: repository)
    }()
    
    private lazy var saveSpokenLanguageUseCase: SaveSpokenLanguageUseCase = {
        SaveSpokenLanguageUseCase(repository: repository)
    }()

    private lazy var deleteSpokenLanguageUseCase: DeleteSpokenLanguageUseCase = {
        DeleteSpokenLanguageUseCase(repository: repository)
    }()
    
    private lazy var client: LanguagesClient = {
        LanguagesClient.live(
            loadLanguagesJSONUseCase: loadLanguagesJSONUseCase,
            fetchSpokenLanguagesUseCase: fetchSpokenLanguagesUseCase,
            saveSpokenLanguageUseCase: saveSpokenLanguageUseCase,
            deleteSpokenLanguageUseCase: deleteSpokenLanguageUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.languagesClient = client
    }
    
}
