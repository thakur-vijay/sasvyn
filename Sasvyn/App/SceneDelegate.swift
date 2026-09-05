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
import CoreSpotlight
import SVSpotlightKit

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
        
        if let userActivity = connectionOptions.userActivities.first(where: { $0.activityType == CSSearchableItemActionType }) {
            handleSpotlight(userActivity)
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
    
    private func handleSpotlight(
        _ userActivity: NSUserActivity
    ) {
        guard let identifier = userActivity.userInfo?[
            CSSearchableItemActivityIdentifier
        ] as? String,
        let destination = SVSpotlightDestination(
            identifier: identifier
        ) else {
            return
        }

        Task { @MainActor in
            AppDelegate.rootDIContainer?.send(
                .spotlightAction(destination)
            )
        }
    }
    
    func scene(
        _ scene: UIScene,
        continue userActivity: NSUserActivity
    ) {
        handleSpotlight(userActivity)
    }
}
