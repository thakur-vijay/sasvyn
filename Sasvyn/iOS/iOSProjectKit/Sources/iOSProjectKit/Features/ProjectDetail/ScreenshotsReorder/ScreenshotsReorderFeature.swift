//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 22/08/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ScreenshotsReorderFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var screenshots: [ProjectScreenshot] = (1...20).map { index in
            ProjectScreenshot(id: UUID(), order: index)
        }
        public init(){
            
        }
    }
    
    public enum Action {
        case reorder(_ sourceIndex: Int, _ destinationIndex: Int)
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
            }
        }
    }
}
