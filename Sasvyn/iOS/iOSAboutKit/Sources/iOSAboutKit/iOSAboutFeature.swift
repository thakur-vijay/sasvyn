//
//  File.swift
//  iOSAboutKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import ComposableArchitecture
import SVAboutKit
import Foundation

@Reducer
public struct iOSAboutFeature {
    
    @Dependency(\.aboutClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var about: About
        public init(_ userId: String){
            self.about = .init(userId: userId, content: "")
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case onTask
        case aboutLoaded(About)
        case onContentChange
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask:
                let userId = state.about.userId
                return .run {[client] send in
                    do {
                        let about = try await client.fetch(userId)
                        await send(.aboutLoaded(about))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .aboutLoaded(let about):
                state.about = about
                return .none
            case .binding(_):
                return .none
            case .onContentChange:
                let about = state.about
                return .run { [client] send in
                    do {
                        try await client.save(about)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
