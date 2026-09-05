//
//  SceneDelegate.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 05/09/26.
//

import UIKit
import SVFoundation
import SVDIInfra
import iOSRootKit

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        handleQuickAction(shortcutItem)
        completionHandler(true)
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            handleQuickAction(shortcutItem)
        }
    }
    
    private func handleQuickAction(
        _ shortcutItem: UIApplicationShortcutItem
    ) {
        guard let action = QuickAppAction(rawValue: shortcutItem.type) else {
            return
        }
        Task { @MainActor in
            AppDelegate.rootDIContainer?.send(.quickAppAction(action))
        }
    }
}
