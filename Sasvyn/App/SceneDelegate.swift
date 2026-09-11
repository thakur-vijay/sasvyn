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
import AppIntents
import SVShortcutsKit

final class SceneDelegate: NSObject, UIWindowSceneDelegate, AppIntentSceneDelegate{
   
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
        
        if let appIntent = connectionOptions.appIntent {
            handleAppIntent(appIntent)
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
    
    private func handleAppIntent(_ appIntent: any UISceneAppIntent) {
        if appIntent is CreateProjectIntent {
            AppDelegate.rootDIContainer?.send(
                .quickAppAction(.newProject)
            )
        }
        
        if appIntent is CreateMockupIntent {
            AppDelegate.rootDIContainer?.send(.quickAppAction(.createMockup))
        }
    }
    
    func scene(
        _ scene: UIScene,
        continue userActivity: NSUserActivity
    ) {
        handleSpotlight(userActivity)
    }
    
    func scene(_ scene: UIScene, willPerformAppIntent appIntent: any UISceneAppIntent) {
        handleAppIntent(appIntent)
    }
    
}
