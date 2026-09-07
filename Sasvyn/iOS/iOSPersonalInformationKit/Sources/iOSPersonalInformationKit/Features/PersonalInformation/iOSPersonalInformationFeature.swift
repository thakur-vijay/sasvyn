//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
public struct iOSPersonalInfomationFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isPhotosPickerPresented: Bool = false
        var selectedItem: PhotosPickerItem?
        public init(){
            
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case destinationTapped(PersonalInformationDestination)
        case changeProfilePicTapped
    }
    
    @Reducer
    public enum Destination {
        case nameEditor(NameEditorFeature)
        case dateOfBirthEditor(DateOfBirthEditorFeature)
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .destination(_):
                return .none
            case .destinationTapped(let destination):
                switch destination {
                case .name:
                    state.destination = .nameEditor(
                        .init(
                            userId: "test_user_id",
                            firstName: "Vijay",
                            lastName: "Thakur"
                        )
                    )
                case .email:
                    break
                case .dateOfBirth:
                    state.destination = .dateOfBirthEditor(
                        .init(
                            userId: "test_user_id",
                            dateOfBirth: .now
                        )
                    )
                case .phoneNo:
                    break
                }
                return .none
            case .changeProfilePicTapped:
                state.isPhotosPickerPresented = true
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSPersonalInfomationFeature.Destination.State: Equatable {}
