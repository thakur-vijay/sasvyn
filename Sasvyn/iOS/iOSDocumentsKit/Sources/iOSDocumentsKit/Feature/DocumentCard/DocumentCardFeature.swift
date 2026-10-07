//
//  File.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import ComposableArchitecture
import SVDocumentKit

@Reducer
public struct DocumentCardFeature {
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: String
        public let document: Document

        public init(document: Document) {
            self.id = document.id
            self.document = document
        }
    }
    
    public enum Action {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
