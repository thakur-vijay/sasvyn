//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import SVNetwork

public struct AuthClient: Sendable {
    
    public var signInWithApple:
        @Sendable (_ body: SocialLoginRequest) async throws -> Void
        
    public var currentUser:
        @Sendable () async -> AuthSession?
    
    public var logout:
        @Sendable () async throws -> Void
}

extension AuthClient {
    
    static func live(
        signInWithAppleUseCase: SignInWithAppleUseCase,
        authSessionUseCase: AuthSessionUseCase,
        logoutUseCase: LogoutUseCase
    ) -> Self {
        Self(
            signInWithApple: { body in
                try await signInWithAppleUseCase.execute(body)
            },
            currentUser: {
                await authSessionUseCase.execute()
            },
            logout: {
                try await logoutUseCase.execute()
            }
        )
    }
}

extension AuthClient: DependencyKey {
    
    public static let liveValue = Self(
        signInWithApple: { _ in
            fatalError("Unimplemented")
        },
        currentUser: {
            fatalError("Unimplemented")
        },
        logout: {
            fatalError("Unimplemented")
        }
    )
}

extension AuthClient: TestDependencyKey {
    
    public static let testValue = Self(
        signInWithApple: { _ in },
        currentUser: {
            nil
        },
        logout: {}
    )
}

public extension DependencyValues {
    
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
