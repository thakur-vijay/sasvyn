//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture

public struct AboutClient: Sendable{
    public var fetch:
    @Sendable (_ userId: String) async throws -> About

    public var save:
    @Sendable (_ about: About) async throws -> Void
}

extension AboutClient {

    static func live(
        fetchAboutUseCase: FetchAboutUseCase,
        saveAboutUseCase: UpdateAboutUseCase,
    ) -> Self {

        Self { userId in
            try await fetchAboutUseCase.execute(userId)
        } save: { about in
            try await saveAboutUseCase.execute(about)
        }

    }
}

extension AboutClient: DependencyKey {

    public static let liveValue = Self { userId in
        fatalError("Unimplemented")
    } save: { about in
        fatalError("Unimplemented")
    }
}

extension AboutClient: TestDependencyKey {

    public static let testValue = Self { userId in
        return .init(userId: "", content: "")
    } save: { about in
        
    }
}

public extension DependencyValues {

    var aboutClient: AboutClient {
        get { self[AboutClient.self] }
        set { self[AboutClient.self] = newValue }
    }
}
