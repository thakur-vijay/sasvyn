//
//  AppDelegate.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 05/09/26.
//

import UIKit
import SVDIInfra

final class AppDelegate: NSObject, UIApplicationDelegate {
    static var rootDIContainer: RootDIContainer?
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
