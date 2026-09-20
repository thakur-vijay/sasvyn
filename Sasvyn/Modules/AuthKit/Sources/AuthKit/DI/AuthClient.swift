//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture

public struct AuthClient: Sendable{
    public var signInWithApple:
    @Sendable (_ body: LoginRequestDTO) async throws -> Void
}

extension AuthClient {

    static func live(
        signInWithAppleUseCase: SignInWithAppleUseCase,
    ) -> Self {
        Self { body in
            try await signInWithAppleUseCase.execute(body)
        }
    }
}

extension AuthClient: DependencyKey {

    public static let liveValue = Self { body in
        fatalError("Unimplemented")
    }
}

extension AuthClient: TestDependencyKey {

    public static let testValue = Self { body in
       
    }
}

public extension DependencyValues {

    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
