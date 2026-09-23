//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI
import SVPersonalInformationKit
import SVFoundation

@Reducer
public struct iOSPersonalInfomationFeature {
    @Dependency(\.usersClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        var isPhotosPickerPresented: Bool = false
        var selectedItem: PhotosPickerItem?
        
        var user: User
        public init(_ user: User){
            self.user = user
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case destinationTapped(PersonalInformationDestination)
        case changeProfilePicTapped
        case onProfilePicChanged
        case userDataChanged
        case onProfilePicUrlLoaded(URL)
        case delegate(Delegate)
        
        public enum Delegate {
            case update(User)
        }
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
            case .destinationTapped(let destination):
                switch destination {
                case .name:
                    let parts = state.user.fullName
                        .split(separator: " ", maxSplits: 1)
                        .map(String.init)

                    let firstName = parts.first ?? ""
                    let lastName = parts.count > 1 ? parts[1] : ""
                    state.destination = .nameEditor(
                        .init(
                            userId: state.user.id,
                            firstName: firstName,
                            lastName: lastName
                        )
                    )
                case .email:
                    break
                case .dateOfBirth:
                    state.destination = .dateOfBirthEditor(
                        .init(
                            userId: state.user.id,
                            dateOfBirth: state.user.dateOfBirth ?? .now
                        )
                    )
                case .phoneNo:
                    break
                }
                return .none
            case .changeProfilePicTapped:
                state.isPhotosPickerPresented = true
                return .none
            case .destination(.presented(.nameEditor(.delegate(.close)))):
                state.destination = nil
                return .none
            case let .destination(.presented(.nameEditor(.delegate(.update(userId, firstName, lastName))))):
                state.user.fullName = "\(firstName) \(lastName)"
                state.destination = nil
                return .send(.userDataChanged)
            case .destination(.presented(.dateOfBirthEditor(.delegate(.close)))):
                state.destination = nil
                return .none
            case let .destination(.presented(.dateOfBirthEditor(.delegate(.update(userId, dateOfBirth))))):
                state.user.dateOfBirth = dateOfBirth
                state.destination = nil
                return .send(.userDataChanged)
            case .destination(_):
                return .none
            case .userDataChanged:
                let user = state.user
                return .run {[client] send in
                    do {
                        try await client.update(user)
                        await send(.delegate(.update(user)))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            case .onProfilePicChanged:
                guard let item = state.selectedItem else {
                    return .none
                }

                return .run { send in
                    do {
                        guard let imageLocalURL = try await UserImageCreator.prepareProfileImageURL(item) else {
                            return
                        }
                        await send(.onProfilePicUrlLoaded(imageLocalURL))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .onProfilePicUrlLoaded(let localImageUrl):
                state.user.imageLocalUrl = localImageUrl
                let user = state.user

                return .run { [client] send in
                    do {
                        try await client.updateImage(user)
                        await send(
                            .delegate(.update(user))
                        )
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSPersonalInfomationFeature.Destination.State: Equatable {}

enum UserImageCreator {
    static func prepareProfileImageURL(
        _ item: PhotosPickerItem
    ) async throws -> URL? {
        guard let data = try await item.loadTransferable(
            type: Data.self
        ) else {
            return nil
        }

        let fileURL = try UserImageStorage.userImageURL(
            for: "profile-image.jpg"
        )

        try data.write(
            to: fileURL,
            options: .atomic
        )
        print("User image url", fileURL)
        return fileURL.appending(queryItems: [.init(name: "v", value: UUID().uuidString)])
    }
}
