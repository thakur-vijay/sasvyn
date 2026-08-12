//
//  File.swift
//  iOSAboutKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSAboutView: View {
    let store: StoreOf<iOSAboutFeature>
    
    public init(store: StoreOf<iOSAboutFeature>) {
        self.store = store
    }
    
    @State private var about: String = ""
    public var body: some View {
        TextEditor(text: $about)
            .scrollContentBackground(.hidden)
            .overlay(alignment: .topLeading){
                if about.isEmpty {
                    Text("Start typing...")
                        .foregroundStyle(.gray)
                        .offset(x: 5, y: 10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
    }
}
