//
//  File.swift
//  iOSEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import ComposableArchitecture
import Foundation
import SVFoundation
import SVEducationKit

@Reducer
public struct EducationFormFeature {
    @Dependency(\.educationsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        let mode: EducationFormMode
        var education: Education
        init(education: Education, mode: EducationFormMode){
            self.education = education
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case closeTapped
        case saveTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update(Education)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .saveTapped:
                let education = state.education
                let mode = state.mode
                return .run { [client] send in
                    do {
                        if mode == .create {
                            try await client.add(education)
                        }else {
                            try await client.update(education)
                        }
                        await send(.delegate(.update(education)))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .delegate(_):
                return .none
            case .closeTapped:
                return .send(.delegate(.close))
            }
        }
    }
}

extension EducationFormFeature.State {
    var isDetailsReady: Bool {
        return education.degree.isNotEmpty && education.fieldOfStudy.isNotEmpty && education.institution.isNotEmpty && education.grade.isNotEmpty && (education.startDate < education.endDate)
    }
}
