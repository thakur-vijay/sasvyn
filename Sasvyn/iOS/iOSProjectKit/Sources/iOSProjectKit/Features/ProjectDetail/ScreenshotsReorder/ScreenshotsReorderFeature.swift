//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 22/08/26.
//

import ComposableArchitecture
import Foundation
import SVProjectKit

@Reducer
public struct ScreenshotsReorderFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var screenshots: [ProjectScreenshot]
        public init(screenshots: [ProjectScreenshot]){
            self.screenshots = screenshots
        }
    }
    
    public enum Action {
        case reorder(_ sourceIndex: Int, _ destinationIndex: Int)
        case checkTapped
        case closeTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case update([ProjectScreenshot])
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .reorder(let sourceIndex, let destinationIndex):
                let sourceItem = state.screenshots.remove(at: sourceIndex)
                state.screenshots.insert(sourceItem, at: destinationIndex)
                return .none
            case .delegate(_):
                return .none
            case .checkTapped:
                for index in 0..<state.screenshots.count {
                    state.screenshots[index].order = index + 1
                }
                return .send(.delegate(.update(state.screenshots)))
            case .closeTapped:
                return .send(.delegate(.close))
            }
        }
    }
}

