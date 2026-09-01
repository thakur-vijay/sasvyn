//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct SocialLinksClient: Sendable{
    public var fetch:
    @Sendable () async throws -> [SocialLink]
    
    public var delete:
    @Sendable (_ id: String) async throws -> Void
    
    public var add:
    @Sendable (_ link: SocialLink) async throws -> Void
    
    public var update:
    @Sendable (_ link: SocialLink) async throws -> Void
    
}

extension SocialLinksClient {

    static func live(
        fetchSocialLinksUseCase: FetchSocialLinksUseCase,
        addSocialLinkUseCase: AddSocialLinkUseCase,
        updateSocialLinkUseCase: UpdateSocialLinkUseCase,
        deleteSocialLinkUseCase: DeleteSocialLinkUseCase
    ) -> Self {
        Self {
            try await fetchSocialLinksUseCase.execute()
        } delete: { id in
            try await deleteSocialLinkUseCase.execute(id)
        } add: { link in
            try await addSocialLinkUseCase.execute(link)
        } update: { link in
            try await updateSocialLinkUseCase.execute(link)
        }
    }
}

extension SocialLinksClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } add: { link in
        fatalError("Unimplemented")
    } update: { link in
        fatalError("Unimplemented")
    }
}

extension SocialLinksClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } add: { link in
        
    } update: { link in
        
    }

}

public extension DependencyValues {

    var socialLinksClient: SocialLinksClient {
        get { self[SocialLinksClient.self] }
        set { self[SocialLinksClient.self] = newValue }
    }
}
