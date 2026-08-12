//
//  File.swift
//  iOSSettingsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSSettingsView: View {
    let store: StoreOf<iOSSettingsFeature>
    
    public init(store: StoreOf<iOSSettingsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
