public struct AddExperienceUseCase: Sendable {
    private let repository: ExperiencesRepository
    init(repository: ExperiencesRepository) { self.repository = repository }
    func execute(_ experience: Experience) async throws { try await repository.add(experience) }
}

public struct FetchExperiencesUseCase: Sendable {
    private let repository: ExperiencesRepository
    init(repository: ExperiencesRepository) { self.repository = repository }
    func execute() async throws -> [Experience] { try await repository.fetch() }
}

public struct UpdateExperienceUseCase: Sendable {
    private let repository: ExperiencesRepository
    init(repository: ExperiencesRepository) { self.repository = repository }
    func execute(_ experience: Experience) async throws { try await repository.update(experience) }
}

public struct DeleteExperienceUseCase: Sendable {
    private let repository: ExperiencesRepository
    init(repository: ExperiencesRepository) { self.repository = repository }
    func execute(id: String) async throws { try await repository.delete(id: id) }
}
