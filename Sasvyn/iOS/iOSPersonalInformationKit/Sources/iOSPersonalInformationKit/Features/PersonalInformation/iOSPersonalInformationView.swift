//
//  File.swift
//  iOSPersonalInformationKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI
import ComposableArchitecture

public struct iOSPersonalInfomationView: View {
    let store: StoreOf<iOSPersonalInfomationFeature>
    
    public init(store: StoreOf<iOSPersonalInfomationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
