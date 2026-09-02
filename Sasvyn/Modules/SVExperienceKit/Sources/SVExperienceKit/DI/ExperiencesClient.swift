import ComposableArchitecture

public struct ExperiencesClient: Sendable {
    public var fetch: @Sendable () async throws -> [Experience]
    public var delete: @Sendable (_ id: String) async throws -> Void
    public var add: @Sendable (_ experience: Experience) async throws -> Void
    public var update: @Sendable (_ experience: Experience) async throws -> Void
}

extension ExperiencesClient {
    static func live(
        fetchExperiencesUseCase: FetchExperiencesUseCase,
        addExperienceUseCase: AddExperienceUseCase,
        updateExperienceUseCase: UpdateExperienceUseCase,
        deleteExperienceUseCase: DeleteExperienceUseCase
    ) -> Self {
        Self {
            try await fetchExperiencesUseCase.execute()
        } delete: { id in
            try await deleteExperienceUseCase.execute(id: id)
        } add: { experience in
            try await addExperienceUseCase.execute(experience)
        } update: { experience in
            try await updateExperienceUseCase.execute(experience)
        }
    }
}

extension ExperiencesClient: DependencyKey {
    public static let liveValue = Self(
        fetch: { fatalError("Unimplemented") },
        delete: { _ in fatalError("Unimplemented") },
        add: { _ in fatalError("Unimplemented") },
        update: { _ in fatalError("Unimplemented") }
    )
}

extension ExperiencesClient: TestDependencyKey {
    public static let testValue = Self(fetch: { [] }, delete: { _ in }, add: { _ in }, update: { _ in })
}

public extension DependencyValues {
    var experiencesClient: ExperiencesClient {
        get { self[ExperiencesClient.self] }
        set { self[ExperiencesClient.self] = newValue }
    }
}
