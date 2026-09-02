import ComposableArchitecture
import SVDatabaseKit

@available(iOS 17.0, *)
public final class ExperiencesDIContainer {
    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    private lazy var dataSource = ExperiencesLocalDataSource(database: database)
    private lazy var repository: ExperiencesRepository = DefaultExperiencesRepository(dataSource: dataSource)
    private lazy var addExperienceUseCase = AddExperienceUseCase(repository: repository)
    private lazy var fetchExperiencesUseCase = FetchExperiencesUseCase(repository: repository)
    private lazy var updateExperienceUseCase = UpdateExperienceUseCase(repository: repository)
    private lazy var deleteExperienceUseCase = DeleteExperienceUseCase(repository: repository)
    private lazy var client = ExperiencesClient.live(
        fetchExperiencesUseCase: fetchExperiencesUseCase,
        addExperienceUseCase: addExperienceUseCase,
        updateExperienceUseCase: updateExperienceUseCase,
        deleteExperienceUseCase: deleteExperienceUseCase
    )

    public func register(_ values: inout DependencyValues) {
        values.experiencesClient = client
    }
}
