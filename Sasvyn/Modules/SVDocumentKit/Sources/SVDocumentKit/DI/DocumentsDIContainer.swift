//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture

@available(iOS 17.0, *)
public final class DocumentsDIContainer{

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource: DocumentsLocalDataSource = {
        DocumentsLocalDataSource(database: database)
    }()

    private lazy var repository: DocumentsRepository = {
        DefaultDocumentsRepository(dataSource: dataSource)
    }()
    
    private lazy var addDocumentUseCase: AddDocumentUseCase = {
        AddDocumentUseCase(repository: repository)
    }()
    
    private lazy var fetchDocumentsUseCase: FetchDocumentsUseCase = {
        FetchDocumentsUseCase(repository: repository)
    }()
    
    private lazy var deleteDocumentUseCase: DeleteDocumentUseCase = {
        DeleteDocumentUseCase(repository: repository)
    }()
    
    private lazy var client: DocumentsClient = {
        DocumentsClient.live(
            fetchDocumentsUseCase: fetchDocumentsUseCase,
            addDocumentUseCase: addDocumentUseCase,
            deleteDocumentUseCase: deleteDocumentUseCase
        )
    }()
    
    public func register(_ values: inout DependencyValues) {
        values.documentsClient = client
    }
    
}
