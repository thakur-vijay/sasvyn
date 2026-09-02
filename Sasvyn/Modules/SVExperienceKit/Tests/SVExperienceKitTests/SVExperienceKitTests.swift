import Testing
@testable import SVExperienceKit

@Test func currentExperienceClearsEndDate() {
    let experience = Experience(
        id: "experience",
        endDate: .now,
        isCurrentlyWorking: true
    )

    #expect(experience.endDate == nil)
}
