//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVProjectKit

@Reducer
public struct iOSProjectDetailFeature {
    
    @Dependency(\.projectsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var mode: ProjectMode
        public init(mode: ProjectMode, id: String){
            self.project = .init(id: id)
            self.mode = mode
            self.appInfo = .init(mode: mode)
            self.overview = .init(mode: mode)
            self.role = .init(mode: mode)
            self.techStack = .init(mode: mode)
            self.screenshots = .init(mode: mode)
        }
        
        var project: Project
        var appInfo: AppInfoFeature.State
        var overview: OverviewFeature.State
        var role: RoleFeature.State
        var techStack: TechStackFeature.State
        var screenshots: ScreenshotsFeature.State
   
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case projectLoaded(Project)
        case editModeTapped
        case cancelEditTapped
        case saveTapped
        case projectSaved
        case appInfo(AppInfoFeature.Action)
        case overview(OverviewFeature.Action)
        case role(RoleFeature.Action)
        case techStack(TechStackFeature.Action)
        case screenshots(ScreenshotsFeature.Action)
        case delegate(Delegate)
        
        public enum Delegate {
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
                    .send(.techStack(.setData(project.techStack)))
                )
            case .binding(_):
                return .none
            case .appInfo, .overview, .role, .screenshots:
                return .none
            case .editModeTapped:
                state.mode = state.mode == .view ? .edit : .view

                let mode = state.mode

                return .merge(
                    .send(.appInfo(.modeChanged(mode))),
                    .send(.overview(.modeChanged(mode))),
                    .send(.role(.modeChanged(mode))),
                    .send(.techStack(.modeChanged(mode))),
                    .send(.screenshots(.modeChanged(mode))),
                )
            case .cancelEditTapped:
                return .none
            case .saveTapped:
                state.appInfo.update(into: &state.project)
                state.overview.update(into: &state.project)
                state.role.update(into: &state.project)
                state.techStack.update(into: &state.project)
                state.screenshots.update(into: &state.project)
                let project = state.project
                let mode = state.mode
                return .run {[client] send in
                    do {
                        if mode == .edit {
                            try await client.update(project)
                        }else {
                            try await client.add(project)
                        }
                        await send(.projectSaved)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .projectSaved:
                if state.mode == .edit {
                    return .send(.editModeTapped)
                }else {
                    return .send(.delegate(.projectUpdated(state.project)))
                }
            case .delegate(_):
                return .none
            case .techStack(_):
                return .none
            }
        }
    }
}

internal extension iOSProjectDetailFeature.State {
    var isProjectReadyToAdd: Bool {
        return (
            appInfo.isDetailsReady && overview.isDetailsReady && role.isDetailsReady && techStack.isDetailsReady && screenshots.isDetailsReady
        )
    }
}
