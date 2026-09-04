//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 01/09/26.
//

import SwiftUI

public struct WebView: View {
    private let item: WebItem
    
    public init(item: WebItem) {
        self.item = item
    }
    
    public var body: some View {
        SafariView(item: item)
    }
}

public extension View {
    @ViewBuilder
    func web(_ item: Binding<WebItem?>)-> some View {
        self
            .sheet(item: item) { value in
                WebView(item: value)
                    .interactiveDismissDisabled()
            }
    }
}
