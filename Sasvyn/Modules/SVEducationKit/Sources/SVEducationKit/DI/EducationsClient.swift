//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct EducationsClient: Sendable{
    public var fetch:
        @Sendable () async throws -> [Education]

    public var delete:
    @Sendable (_ id: String) async throws -> Void

    public var add:
    @Sendable (_ education: Education) async throws -> Void
     
    public var update:
    @Sendable (_ education: Education) async throws -> Void
    
}

extension EducationsClient {

    static func live(
        fetchEducationsUseCase: FetchEducationsUseCase,
        addEducationUseCase: AddEducationUseCase,
        updateEducationUseCase: UpdateEducationUseCase,
        deleteEducationUseCase: DeleteEducationUseCase,
    ) -> Self {

        Self {
            try await fetchEducationsUseCase.execute()
        } delete: { id in
            try await deleteEducationUseCase.execute(id)
        } add: { education in
            try await addEducationUseCase.execute(education)
        } update: { education in
            try await updateEducationUseCase.execute(education)
        }
    }
}

extension EducationsClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { education in
        fatalError("Unimplemented")
    } update: { education in
        fatalError("Unimplemented")
    }
}

extension EducationsClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } add: { education in
        
    } update: { education in
        
    }

}

public extension DependencyValues {

    var educationsClient: EducationsClient {
        get { self[EducationsClient.self] }
        set { self[EducationsClient.self] = newValue }
    }
}
