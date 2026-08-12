//
//  File.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSPortfolioView: View {
    let store: StoreOf<iOSPortfolioFeature>
    
    public init(store: StoreOf<iOSPortfolioFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                
            }
            .navigationTitle("Portfolios")
            .searchable(text: .constant(""), placement: .toolbar, prompt: Text("Search portfolio..."))
        }
    }
}
