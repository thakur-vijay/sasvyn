//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct DocumentsClient: Sendable{
    public var fetch:
        @Sendable (_ category: DocumentCategory?) async throws -> [Document]

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ document: Document) async throws -> Void
    
    public var `import`: @Sendable (_ from: URL, _ category: DocumentCategory) async throws -> Document
    
}

extension DocumentsClient {

    private static func importDocument(from url: URL, category: DocumentCategory) throws -> Document {

        guard url.startAccessingSecurityScopedResource() else {
            throw DocumentsError.securityScopedResourceAccessFailed
        }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        let documentsDirectory = try DocumentStorage.documentsDirectory()

        let destinationURL = documentsDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(url.pathExtension)

        try FileManager.default.copyItem(
            at: url,
            to: destinationURL
        )

        let values = try destinationURL.resourceValues(
            forKeys: [
                .fileSizeKey,
                .contentModificationDateKey
            ]
        )

        return Document(
            id: UUID().uuidString,
            url: destinationURL,
            name: url.lastPathComponent,
//            createdAt: values.contentModificationDate ?? Date(),
            createdAt: Date(),
            fileSize: Int64(values.fileSize ?? 0),
            category: category
        )
    }
}

public enum DocumentsError: Error {
    case securityScopedResourceAccessFailed
}

extension DocumentsClient {

    static func live(
        fetchDocumentsUseCase: FetchDocumentsUseCase,
        addDocumentUseCase: AddDocumentUseCase,
        deleteDocumentUseCase: DeleteDocumentUseCase,
    ) -> Self {

        Self { category in
            try await fetchDocumentsUseCase.execute(category: category)
        } delete: { id in
            try await deleteDocumentUseCase.execute(id: id)
        } add: { document in
            try await addDocumentUseCase.execute(document: document)
        } `import`: { url, category in
            try self.importDocument(from: url, category: category)
        }

    }
}

extension DocumentsClient: DependencyKey {

    public static let liveValue = Self { category in
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { skills in
        fatalError("Unimplemented")
    } `import`: { url, category in
        fatalError("Unimplemented")
    }

    
}

extension DocumentsClient: TestDependencyKey {

    public static let testValue = Self { category in
        return []
    } delete: { id in
        
    } add: { skills in
        
    } `import`: { url, category in
        Document(
            id: "test-document",
            url: url,
            name: "Test.pdf",
            createdAt: Date(),
            fileSize: 0,
            category: .portfolio
        )
    }

}

public extension DependencyValues {

    var documentsClient: DocumentsClient {
        get { self[DocumentsClient.self] }
        set { self[DocumentsClient.self] = newValue }
    }
}
