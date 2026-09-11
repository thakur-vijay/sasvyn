//
//  SVShortcutsProvider.swift
//  SVShortcutsKit
//
//  Created by Vijay Thakur on 10/09/26.
//


import AppIntents

public struct SVShortcutsProvider: AppShortcutsProvider {

    public static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: CreateProjectIntent(),
                phrases: [
                    "Create a project in \(.applicationName)",
                    "New project in \(.applicationName)"
                ],
                shortTitle: "Create Project",
                systemImageName: "folder.badge.plus"
            ),
            AppShortcut(
                intent: CreateMockupIntent(),
                phrases: [
                    "Create a mockup in \(.applicationName)",
                    "New mockup in \(.applicationName)",
                    "Create mockups in \(.applicationName)",
                ],
                shortTitle: "Create Mockup",
                systemImageName: "iphone"
            )
        ]
    }
}
