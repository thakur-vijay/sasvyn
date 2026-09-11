//
//  CreateProjectIntent.swift
//  SVShortcutsKit
//
//  Created by Vijay Thakur on 10/09/26.
//


import AppIntents
import _AppIntents_UIKit

public struct CreateProjectIntent: AppIntent, UISceneAppIntent {

    public nonisolated static let title: LocalizedStringResource = "Create Project"

    public nonisolated static var supportedModes: IntentModes {
        .foreground
    }

    public init() {}

    public func perform() async throws -> some IntentResult {
        .result()
    }
}
