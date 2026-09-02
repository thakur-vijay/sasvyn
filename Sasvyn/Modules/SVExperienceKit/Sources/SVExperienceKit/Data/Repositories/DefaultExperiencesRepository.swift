public final class DefaultExperiencesRepository: ExperiencesRepository {
    private let dataSource: ExperiencesLocalDataSource

    init(dataSource: ExperiencesLocalDataSource) {
        self.dataSource = dataSource
    }

    public func fetch() async throws -> [Experience] {
        try await dataSource.fetch().map { record, responsibilities in
            ExperienceRecordMapper.map(record, responsibilities: responsibilities)
        }
    }

    public func add(_ experience: Experience) async throws {
        try await dataSource.create(experience)
    }

    public func update(_ experience: Experience) async throws {
        try await dataSource.update(experience)
    }

    public func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
