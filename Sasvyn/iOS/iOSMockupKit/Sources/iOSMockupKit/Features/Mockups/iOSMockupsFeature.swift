//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import ComposableArchitecture
import SVMockupKit

@Reducer
public struct iOSMockupsFeature {
    
    @Dependency(\.mockupsClient)
    private var client
    
    @Dependency(\.photosClient)
    private var photosClient
    
    @ObservableState
    public struct State: Equatable {
        public var mockups: [MockupImage] = []
        public var selectedMockup: MockupImage?
        public var mode: MockupsPresentationMode
        public var isSingleSelection: Bool
        public init(
            mode: MockupsPresentationMode,
            selectedMockupIds: Set<String> = .init(),
            maxSelection: Int? = 0
        ){
            self.mode = mode
            self.selectedMockupIds = selectedMockupIds
            self.maxSelection = maxSelection
            self.isSingleSelection = false
        }
        
        public init(
            mode: MockupsPresentationMode,
            selection: String?,
        ){
            self.selection = selection
            self.mode = mode
            self.selectedMockupIds = []
            self.maxSelection = nil
            self.isSingleSelection = true
        }
        
        @Presents
        public var destination: Destination.State?
        
        var selectedMockupIds: Set<String>
        var maxSelection: Int?
        var selection: String?
        
        var selectedMockups: [MockupImage] {
            mockups
                .filter { selectedMockupIds.contains($0.id) }
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case addTapped
        case checkTapped
        case closeTapped
        case onTask
        case mockupsReady([MockupImage])
        case deleteTapped(MockupImage)
        case mockupTapped(MockupImage)
        case mockupDeleted(MockupImage)
        case saveToPhotosTapped(MockupImage)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case selection([MockupImage])
            case select(MockupImage?)
        }
    }
    
    public init(){
        
    }
    
    @Reducer
    public enum Destination {
        case iOSCreateMockup(iOSCreateMockupFeature)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .addTapped:
                state.destination = .iOSCreateMockup(.init())
                return .none
            case .onTask:
                return .run {[client] send in
                    do {
                        let mockups = try await client.fetch()
                        await send(.mockupsReady(mockups))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .mockupsReady(let mockups):
                state.mockups = mockups
                return .none
            case .destination(.presented(.iOSCreateMockup(.delegate(.addMockup(let newMockup))))):
                state.mockups.append(newMockup)
                return .none
            case .destination(.presented(.iOSCreateMockup(.delegate(.exportFinished)))),
                 .destination(.presented(.iOSCreateMockup(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            case .deleteTapped(let mockup):
                return .run {[client] send in
                    do {
                        try await client.delete(mockup.id)
                        await send(.mockupDeleted(mockup))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .mockupDeleted(let mockup):
                state.mockups.removeAll { $0.id == mockup.id }
                return .none
            case .checkTapped:
                return .send(.delegate(.selection(state.selectedMockups)))
            case .delegate(_):
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            case .mockupTapped(let mockup):
                if state.mode == .picker {
                    if state.isSingleSelection {
                        if state.selection == mockup.id {
                            state.selection = nil
                            return .none
                        }else {
                            return .send(.delegate(.select(mockup)))
                        }
                    }else {
                        if state.selectedMockupIds.contains(mockup.id){
                            state.selectedMockupIds.remove(mockup.id)
                        }else {
                            state.selectedMockupIds.insert(mockup.id)
                        }
                        return .none
                    }
                }else {
                    state.selectedMockup = mockup
                    return .none
                }
              
            case .saveToPhotosTapped(let mockup):
                return .run {[photosClient] send in
                    do {
                        guard let url = mockup.url else { return }
                        try await photosClient.saveImage(url)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSMockupsFeature.Destination.State: Equatable {}
