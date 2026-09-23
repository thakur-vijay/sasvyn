//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct UsersClient: Sendable{
    public var fetchCurrentUser:
    @Sendable () async throws -> User
    
    public var update:
    @Sendable (_ user: User) async throws -> Void
    
    public var updateImage:
    @Sendable (_ user: User) async throws -> Void
}

extension UsersClient {

    static func live(
        fetchCurrentUserUseCase: FetchCurrentUserUseCase,
        updateUserUseCase: UpdateUserUseCase,
        updateUserImageUseCase: UpdateUserImageUseCase,
    ) -> Self {
        Self {
            try await fetchCurrentUserUseCase.execute()
        } update: { user in
            try await updateUserUseCase.execute(user)
        } updateImage: { user in
            try await updateUserImageUseCase.execute(user)
        }
    }
}

extension UsersClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } update: { user in
        fatalError("Unimplemented")
    } updateImage: { user in
        fatalError("Unimplemented")
    }
}

extension UsersClient: TestDependencyKey {

    public static let testValue = Self {
        return .init(
            id: "testing_id",
            appleId: "testing_apple_id",
            fullName: "testing_name",
            email: "testing_email"
        )
    } update: { user in
        
    } updateImage: { user in
        
    }
}

public extension DependencyValues {

    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}
