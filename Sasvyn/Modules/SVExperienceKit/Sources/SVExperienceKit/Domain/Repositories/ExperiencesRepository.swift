public protocol ExperiencesRepository: Sendable {
    func fetch() async throws -> [Experience]
    func add(_ experience: Experience) async throws
    func update(_ experience: Experience) async throws
    func delete(id: String) async throws
}
