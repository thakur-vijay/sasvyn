//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import SVDatabaseKit
import ComposableArchitecture
import NetworkKit
import SVNetwork
import SVSyncKit

@available(iOS 26.0, macOS 15.0, *)
public final class DocumentsDIContainer{

    private let database: AppDatabase
    private let metadataStore: any SyncMetadataStore
    private let networkClient: any NetworkClientProtocol
    private let fileUploader: any FileUploader

    public init(
        database: AppDatabase,
        metadataStore: any SyncMetadataStore,
        networkClient: any NetworkClientProtocol,
        fileUploader: any FileUploader
    ) {
        self.database = database
        self.metadataStore = metadataStore
        self.networkClient = networkClient
        self.fileUploader = fileUploader
    }
    
    private lazy var localDataSource: DocumentsLocalDataSource = {
        DocumentsLocalDataSource(database: database)
    }()

    private lazy var remoteDataSource: DocumentsRemoteDataSource = {
        DocumentsRemoteDataSource(
            client: networkClient,
            fileUploader: fileUploader
        )
    }()
    
    private lazy var syncEngine: any SyncEngine<Document> = {
        DefaultSyncEngine(
            localStore: localDataSource,
            remoteStore: remoteDataSource,
            metadataStore: metadataStore,
            conflictResolver: DefaultSyncConflictResolver(strategy: .localWins)
        )
    }()

    private lazy var repository: DocumentsRepository = {
        DefaultDocumentsRepository(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource,
            syncEngine: syncEngine
        )
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
