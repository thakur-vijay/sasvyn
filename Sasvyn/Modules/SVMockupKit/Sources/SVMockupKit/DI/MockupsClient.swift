//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct MockupsClient: Sendable{
    public var fetch:
        @Sendable () async throws -> [MockupImage]

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ mockup: MockupModel) async throws -> Void
}

extension MockupsClient {

    static func live(
        fetchMockupsUseCase: FetchMockupsUseCase,
        addMockupUseCase: AddMockupUseCase,
        deleteMockupUseCase: DeleteMockupUseCase,
    ) -> Self {

        Self {
            try await fetchMockupsUseCase.execute()
        } delete: { id in
            try await deleteMockupUseCase.execute(id: id)
        } add: { mockup in
            try await addMockupUseCase.execute(mockup: mockup)
        }

    }
}

extension MockupsClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { mockup in
        fatalError("Unimplemented")
    }

    
}

extension MockupsClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } add: { skills in
        
    }
}

public extension DependencyValues {

    var mockupsClient: MockupsClient {
        get { self[MockupsClient.self] }
        set { self[MockupsClient.self] = newValue }
    }
}
