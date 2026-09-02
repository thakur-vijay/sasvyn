import Foundation
import SVFoundation

public struct Experience: Identifiable, Hashable, Sendable {
    public let id: String
    @Trim public var role: String
    @Trim public var company: String
    public var startDate: Date
    public var endDate: Date? {
        didSet {
            if isCurrentlyWorking { endDate = nil }
        }
    }
    public var isCurrentlyWorking: Bool {
        didSet {
            if isCurrentlyWorking { endDate = nil }
        }
    }
    public var responsibilities: [ExperienceResponsibility]

    public init(
        id: String,
        role: String = "",
        company: String = "",
        startDate: Date = .now,
        endDate: Date? = .now,
        isCurrentlyWorking: Bool = false,
        responsibilities: [ExperienceResponsibility] = []
    ) {
        self.id = id
        self.role = role
        self.company = company
        self.startDate = startDate
        self.isCurrentlyWorking = isCurrentlyWorking
        self.endDate = isCurrentlyWorking ? nil : endDate
        self.responsibilities = responsibilities
    }
}
