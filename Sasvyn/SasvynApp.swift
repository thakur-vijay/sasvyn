//
//  SasvynApp.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI

@main
struct SasvynApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
              macOSView()
            #elseif os(iOS)
              iOSView()
            #endif
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)

    }
}

struct iOSView: View {
    var body: some View {
        Text("Hello from iOS")
    }
}

struct macOSView: View {
    var body: some View {
        NavigationSplitView(
            columnVisibility: .constant(.doubleColumn),
            preferredCompactColumn: .constant(.detail)) {
                List {
                    NavigationLink("Home", value: "home")
                    NavigationLink("Projects", value: "projects")
                    NavigationLink("Settings", value: "settings")
                }
                .navigationTitle("Sasvyn")
                .toolbar(removing: .sidebarToggle)
                .navigationSplitViewColumnWidth(220)
                .navigationSplitViewStyle(.balanced)
                .defaultAppStorage(.standard)
            } detail: {
                Text("This is main view")
            }
            .frame(
                minWidth: 900,
                minHeight: 600
            )
    }
}
