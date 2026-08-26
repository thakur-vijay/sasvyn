//
//  SasvynApp.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
#if os(macOS)
import macOSMainKit
#elseif os(iOS)
import iOSRootKit
#endif
import ComposableArchitecture
import SVDIInfra

@main
struct SasvynApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    private let appDIContainer = SVAppDIContainer()
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            macOSMainView(store: .init(initialState: macOSMainFeature.State(), reducer: {
                macOSMainFeature()
            }))
#elseif os(iOS)
            appDIContainer.rootDIContainer.makeView()
                .preferredColorScheme(.dark)
#endif
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)
        
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        configuration.delegateClass = SceneDelegate.self

        return configuration
    }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        print("🔥 QUICK ACTION")
        print(shortcutItem.type)

        handleQuickAction(shortcutItem)

        completionHandler(true)
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        if let shortcutItem = connectionOptions.shortcutItem {
            print("❄️ COLD LAUNCH QUICK ACTION")
            print(shortcutItem.type)

            handleQuickAction(shortcutItem)
        }
    }
    
    private func handleQuickAction(
        _ shortcutItem: UIApplicationShortcutItem
    ) {
        switch shortcutItem.type {

        case "com.sasvyn.new-project":
            print("➡️ New Project")

        case "com.sasvyn.projects":
            print("➡️ My Projects")

        case "com.sasvyn.create-mockup":
            print("➡️ Create Mockup")

        case "com.sasvyn.export-portfolio":
            print("➡️ Export Portfolio")

        default:
            print("❓ Unknown shortcut:", shortcutItem.type)
        }
    }
}
