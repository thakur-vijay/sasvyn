//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVProjectKit

public enum ProjectDetailScreenMode {
    case sheet
    case screen
}

@Reducer
public struct iOSProjectDetailFeature {
    
    @Dependency(\.projectsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public let viewMode: ProjectDetailScreenMode
        public var mode: ProjectMode
        public init(mode: ProjectMode, id: String, viewMode: ProjectDetailScreenMode = .screen){
            self.project = .init(id: id)
            self.mode = mode
            self.viewMode = viewMode
            self.appInfo = .init(mode: mode)
            self.overview = .init(mode: mode)
            self.role = .init(mode: mode)
            self.techStack = .init(mode: mode)
            self.screenshots = .init(mode: mode)
            self.appDescription = .init(mode: mode)
        }
        
        var project: Project
        var appInfo: AppInfoFeature.State
        var overview: OverviewFeature.State
        var role: RoleFeature.State
        var techStack: TechStackFeature.State
        var screenshots: ScreenshotsFeature.State
        var appDescription: DescriptionFeature.State
   
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case projectLoaded(Project)
        case toggleModeTapped
        case closeTapped
        case saveTapped
        case projectSaved
        case updateProject
        case appInfo(AppInfoFeature.Action)
        case overview(OverviewFeature.Action)
        case role(RoleFeature.Action)
        case techStack(TechStackFeature.Action)
        case screenshots(ScreenshotsFeature.Action)
        case appDescription(DescriptionFeature.Action)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case projectAdded(Project)
            case projectUpdated(Project)
        }
    }
    
    public init (){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(\.appInfo, action: \.appInfo) {
            AppInfoFeature()
        }
        
        Scope(\.overview, action: \.overview) {
            OverviewFeature()
        } 
        Scope(\.role, action: \.role) {
            RoleFeature()
        }
        Scope(\.techStack, action: \.techStack) {
            TechStackFeature()
        }
        Scope(\.screenshots, action: \.screenshots) {
            ScreenshotsFeature()
        }
        Scope(\.appDescription, action: \.appDescription) {
            DescriptionFeature()
        }
        Reduce { state, action in
            switch action {
            case .onTask:
                guard state.mode != .create else { return .none }
                let projectID = state.project.id
                return .run { [client] send in
                    do {
                        guard let project = try await client.fetchProject(projectID) else {
                            return
                        }
                        await send(.projectLoaded(project))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .projectLoaded(let project):
                state.project = project
                return .merge(
                    .send(.appInfo(.setData(project.name, project.tagline, project.category, project.icon))),
                    .send(.overview(.setData(project.overview))),
                    .send(.role(.setData(project.role))),
                    .send(.techStack(.setData(project.techStack))),
                    .send(.screenshots(.setData(project.screenshots))),
                    .send(.appDescription(.setData(project.description)))
                )
            case .binding(_):
                return .none
            case .toggleModeTapped:
                state.mode = state.mode == .view ? .edit : .view

                let mode = state.mode
                return .merge(
                    .send(.appInfo(.modeChanged(mode))),
                    .send(.overview(.modeChanged(mode))),
                    .send(.role(.modeChanged(mode))),
                    .send(.techStack(.modeChanged(mode))),
                    .send(.screenshots(.modeChanged(mode))),
                )
            case .saveTapped:
                guard state.isProjectReadyToAdd else { return .none }
                let project = state.project
                let screenshots = state.project.screenshots
                return .run {[client] send in
                    do {
                        try await client.add(project)
                        try await client.addScreenshots(screenshots, project.id)
                        await send(.projectSaved)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .projectSaved:
                if state.mode == .edit {
                    return .send(.delegate(.projectUpdated(state.project)))
                }else {
                    return .send(.delegate(.projectAdded(state.project)))
                }
            case .delegate(_):
                return .none
            case .updateProject:
                guard state.mode == .edit else { return .none }
                let project = state.project
                return .run {[client] send in
                    do {
                        try await client.update(project)
                        await send(.projectSaved)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .overview(.delegate(.overviewChanged)):
                guard state.overview.isDetailsReady else { return .none }
                state.overview.update(into: &state.project)
                return .send(.updateProject)
            case .overview(_):
                return .none
            case .role(.delegate(.roleChanged)):
                guard state.role.isDetailsReady else { return .none }
                state.role.update(into: &state.project)
                return .send(.updateProject)
            case .role(_):
                return .none
            case .appInfo(.delegate(.infoChanged)):
                guard state.appInfo.isDetailsReady else { return .none }
                let updatedAppIcon = state.appInfo.update(into: &state.project)
                return .merge(
                    .send(.updateProject),
                    .send(.appInfo(.updateAppIcon(updatedAppIcon)))
                )
            case .appInfo(_):
                return .none
            case .screenshots(.delegate(.screenshotsUpdated(let removed, let new))):
                state.screenshots.update(into: &state.project)
                let projectID = state.project.id
                let screenshots = state.project.screenshots
                if state.mode == .create {
                    return .none
                }else {
                    return .merge(
                        .run {[client] send in
                            do {
                                guard !removed.isEmpty else { return }
                                try await client.deleteScreenshots(removed)
                            }catch {
                                print(error.localizedDescription)
                            }
                        },
                        .run {[client] send in
                            do {
                                guard !new.isEmpty else { return }
                                try await client.addScreenshots(new, projectID)
                            }catch {
                                print(error.localizedDescription)
                            }
                        },
                        .run { [client] send in
                            do {
                                guard !removed.isEmpty else { return }
                                try await client.reorderScreenshots(screenshots)
                            }catch {
                                print(error.localizedDescription)
                            }
                        }
                    )
                }
            case .screenshots(.delegate(.screenshotUpdated(_, _))):
                return .none
            case .screenshots(.delegate(.screenshotsReordered)):
                state.screenshots.update(into: &state.project)
                let screenshots = state.project.screenshots
                return .run { [client] send in
                    do {
                        try await client.reorderScreenshots(screenshots)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .screenshots(_):
                return .none
            case .techStack(.delegate(.updateStack)):
                guard state.techStack.isDetailsReady else { return .none }
                state.techStack.update(into: &state.project)
                return .send(.updateProject)
            case .techStack(_):
                return .none
            case .appDescription(.delegate(.descriptionChanged)):
                guard state.appDescription.isDetailsReady else { return .none }
                state.appDescription.update(into: &state.project)
                return .send(.updateProject)
            case .appDescription(_):
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            }
        }
    }
}

internal extension iOSProjectDetailFeature.State {
    var isProjectReadyToAdd: Bool {
        return (
            appInfo.isDetailsReady && overview.isDetailsReady && role.isDetailsReady && techStack.isDetailsReady && screenshots.isDetailsReady && appDescription.isDetailsReady
        )
    }
}
