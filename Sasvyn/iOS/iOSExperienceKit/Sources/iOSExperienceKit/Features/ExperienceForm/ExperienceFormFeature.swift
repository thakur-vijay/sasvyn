import ComposableArchitecture
import Foundation
import SVExperienceKit
import SVFoundation

@Reducer
public struct ExperienceFormFeature {
    @Dependency(\.experiencesClient) private var client
    
    @ObservableState
    public struct State: Equatable {
        let mode: ExperienceFormMode
        var experience: Experience
        
        init(experience: Experience, mode: ExperienceFormMode) {
            self.experience = experience
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case closeTapped
        case saveTapped
        case endDateChanged(Date)
//        case responsibilityChanged(index: Int, value: String)
        case addResponsibilityTapped
        case deleteResponsibility(IndexSet)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(Experience)
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .endDateChanged(let date):
                state.experience.endDate = date
                return .none
                //            case .responsibilityChanged(let index, let value):
                //                print("calling it")
                //                guard state.experience.responsibilities.indices.contains(index) else { return .none }
                //                state.experience.responsibilities[index] = value
                //                return .none
            case .addResponsibilityTapped:
                let emptyResponsibility = ExperienceResponsibility(id: UUID().uuidString, experienceID: state.experience.id, responsibility: "")
                state.experience.responsibilities.append(emptyResponsibility)
                return .none
            case .deleteResponsibility(let offsets):
                state.experience.responsibilities.remove(atOffsets: offsets)
                return .none
            case .saveTapped:
                var experience = state.experience
                experience.role = experience.role
                experience.company = experience.company
                experience.responsibilities = experience.responsibilities.filter {
                    $0.responsibility.isNotEmpty
                }
                if experience.isCurrentlyWorking { experience.endDate = nil }
                state.experience = experience
                let mode = state.mode
                return .run { [client, experience] send in
                    do {
                        if mode == .create { try await client.add(experience) }
                        else { try await client.update(experience) }
                        await send(.delegate(.update(experience)))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .closeTapped:
                return .send(.delegate(.close))
            case .binding,
                    .delegate:
                return .none
            }
        }
    }
}

extension ExperienceFormFeature.State {
    var isDetailsReady: Bool {
        experience.role.isNotEmpty 
        && experience.company.isNotEmpty
        && experience.responsibilities.contains { !$0.responsibility.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

enum ExperienceFormMode: Hashable, Sendable {
    case create
    case edit
}
