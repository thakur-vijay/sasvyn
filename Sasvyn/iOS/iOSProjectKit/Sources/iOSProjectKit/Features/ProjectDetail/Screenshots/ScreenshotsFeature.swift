//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture
import SVMockupKit
import iOSMockupKit
import Foundation
import SVProjectKit

@Reducer
public struct ScreenshotsFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var mode: ProjectMode
        public var screenshots: [ProjectScreenshot] = []
        public var selectedScreenshotID: String?
        public var selectedScreenshot: ProjectScreenshot?
        
        public init(mode: ProjectMode) {
            self.mode = mode
        }
        
        
        @Presents
        var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case modeChanged(ProjectMode)
        case screenshotTapped(ProjectScreenshot)
        case reorderTapped
        case addPreviewsTapped
        case deleteScreenshotTapped(ProjectScreenshot)
        case screenshotDeleted(ProjectScreenshot)
        case setData(_ screenshots: [ProjectScreenshot])
        case delegate(Delegate)
        
        public enum Delegate {
            case screenshotsUpdated
            case screenshotUpdated(Int, ProjectScreenshot)
            case screenshotToDelete(ProjectScreenshot)
        }
    }
    
    public init(){}
    
    @Reducer
    public enum Destination {
        case screenshotsReorder(ScreenshotsReorderFeature)
        case mockupsPicker(iOSMockupsFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            case .binding(_):
                return .none
            case .screenshotTapped(let screenshot):
                if state.mode == .view {
                    state.selectedScreenshot = screenshot
                }else {
                    state.selectedScreenshotID = screenshot.id
                    state.destination = .mockupsPicker(
                        .init(
                            mode: .picker,
                            selection: screenshot.mockupID
                        )
                    )
                }
                return .none
            case .reorderTapped:
                state.destination = .screenshotsReorder(.init(screenshots: state.screenshots))
                return .none
            case .destination(.presented(.mockupsPicker(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(.presented(.mockupsPicker(.delegate(.selection(let mockups))))):
                state.destination = nil
                let finalMockupIDs = Set(mockups.map(\.id))

                state.screenshots.removeAll {
                    !finalMockupIDs.contains($0.mockupID)
                }

                let existingMockupIDs = Set(
                    state.screenshots.map(\.mockupID)
                )

                let newMockups = mockups.filter {
                    !existingMockupIDs.contains($0.id)
                }

                for mockup in newMockups {
                    state.screenshots.append(
                        ProjectScreenshot(
                            id: UUID().uuidString,
                            mockupID: mockup.id,
                            device: mockup.device,
                            imageURL: mockup.url,
                            aspectRatio: mockup.aspectRatio,
                            order: 0
                        )
                    )
                }

                for index in state.screenshots.indices {
                    state.screenshots[index].order = index + 1
                }
                return .send(.delegate(.screenshotsUpdated))
            case .destination(.presented(.mockupsPicker(.delegate(.select(let mockup))))):
                state.destination = nil
                if let index = state.screenshots.firstIndex(where: { $0.id == state.selectedScreenshotID }){
                    state.selectedScreenshotID = nil
                    state.screenshots[index].imageURL = mockup?.url
                    state.screenshots[index].mockupID = mockup?.id ?? ""
                    state.screenshots[index].aspectRatio = mockup?.aspectRatio ?? 0
                    state.screenshots[index].device = mockup?.device ?? ""
                    return .send(.delegate(.screenshotUpdated(index, state.screenshots[index])))
                }else {
                    return .none
                }
            case .destination(.presented(.screenshotsReorder(.delegate(.update(let updatedScreenshots))))):
                state.screenshots = updatedScreenshots
                state.destination = nil
                return .send(.delegate(.screenshotsUpdated))
            case .destination(.presented(.screenshotsReorder(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination(_):
                return .none
            case .addPreviewsTapped:
                let alreadySelected = state.screenshots.map(\.mockupID)
                state.destination = .mockupsPicker(
                    .init(
                        mode: .picker,
                        selectedMockupIds: Set(alreadySelected),
                        maxSelection: ProjectConfiguration.screenshotsLimit
                    )
                )
                return .none
            case .setData(let screenshots):
                state.screenshots = screenshots
                return .none
            case .delegate(_):
                return .none
            case .deleteScreenshotTapped(let screenshot):
                if state.mode == .create {
                    state.screenshots.removeAll { $0.id == screenshot.id }
                    for index in 0..<state.screenshots.count {
                        state.screenshots[index].order = index + 1
                    }
                    return .send(.delegate(.screenshotsUpdated))
                }else {
                    return .send(.delegate(.screenshotToDelete(screenshot)))
                }
            case .screenshotDeleted(let screenshot):
                state.screenshots.removeAll { $0.id == screenshot.id }
                for index in 0..<state.screenshots.count {
                    state.screenshots[index].order = index + 1
                }
                return .send(.delegate(.screenshotsUpdated))
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

internal extension ScreenshotsFeature.State {
    var isDetailsReady: Bool {
        !screenshots.isEmpty
    }
    
    func update(into project: inout Project) {
        project.screenshots = screenshots
    }
}

extension ScreenshotsFeature.Destination.State: Equatable {}
